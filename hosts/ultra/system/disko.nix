{ inputs
, globals
, isConfig
, pkgs
, ...
}:{
  imports = [
    inputs.disko.nixosModules.default
  ];

  disko.devices = {
    disk = {
      main = {
        device = builtins.elemAt globals.ultra.drives 0;
        type = "disk";
        content = {
          type = "gpt";
          partitions = {
            esp = {
              name = "ESP";
              start = "1MiB";
              end = "512MiB";
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
                mountOptions = [ "defaults" ];
              };
            };
            luks = {
              size = "100%";
              content = {
                type = "luks";
                name = "crypted";
                passwordFile = "/tmp/luks_password";
                extraFormatArgs = [ "--pbkdf argon2id" ];
                extraOpenArgs = [ "--allow-discards" ];
                content = {
                  type = "lvm_pv";
                  vg = "pool";
                };
              };
            };
          };
        };
      };
    };
    lvm_vg = {
      pool = {
        type = "lvm_vg";
        lvs = {
          system = {
            size = "100%FREE";
            content = {
              type = "btrfs";
              extraArgs = [ "-f" ];
              postCreateHook = ''
                TMP=$(mktemp -d);
                mount -t btrfs -o subvol=root "/dev/${globals.meta.lvmPool}/${globals.meta.lvmLogicalSystem}" "$TMP";
                mkdir -p "$TMP"/{persist,nix,root,.snapshots,.swapvol};
                mount -t btrfs -o subvol=snapshots "/dev/${globals.meta.lvmPool}/${globals.meta.lvmLogicalSystem}" "$TMP/.snapshots";
                trap 'umount -A $TMP; rm -rf $TMP' EXIT;
                btrfs subvolume snapshot -r "$TMP" "$TMP/.snapshots/blank-root";
              '';
              postMountHook = ''
                mkdir -p /mnt${globals.${isConfig}.persistFlakePath}/${globals.meta.flakePath};
                mkdir -p /mnt/persist/system/var/lib/sops-nix
                mkdir -p /mnt/persist/system/etc/ssh
                cp /tmp/${isConfig}{.age,_pub.age} /mnt/persist/system/var/lib/sops-nix ||:
                cp /tmp/${isConfig}{_ed25519_key,_ed25519_key.pub} /mnt/persist/system/etc/ssh ||:
                chmod 0600 "/mnt/persist/system/var/lib/sops-nix/${isConfig}.age"
                trap 'rm -rf /tmp/luks_password;' EXIT;
                cp -rT /dotfiles /mnt${globals.${isConfig}.persistFlakePath}/${globals.meta.flakePath};
              '';
              subvolumes = {
                "/persist" = {
                  mountpoint = "/persist";
                  mountOptions = [ "subvol=persist" "compress=zstd" "noatime" ];
                };
                "/nix" = {
                  mountpoint = "/nix";
                  mountOptions = [ "subvol=nix" "compress=zstd" "noatime" ];
                };
                "/root" = {
                  mountpoint = "/";
                  mountOptions = [ "subvol=root" "compress=zstd" "noatime" ];
                };
                "/swap" = {
                  mountpoint = "/.swapvol";
                  swap.swapfile.size = "4G";
                };
                "/snapshots" = {
                  mountpoint = "/.snapshots";
                  mountOptions = [ "subvol=snapshots" "compress=zstd" "noatime" ];
                };
              };
            };
          };
        };
      };
    };
  };
}
