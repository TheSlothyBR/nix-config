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
        device = builtins.elemAt globals.corsair.drives 0;
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
                name = "first_crypted";
                passwordFile = "/tmp/luks_password";
                extraFormatArgs = [ "--pbkdf argon2id" ];
                extraOpenArgs = [ "--allow-discards" ];
                content = {
                  type = "lvm_pv";
                  vg = "${globals.meta.lvmPool}";
                };
              };
            };
          };
        };
      };
      secondary = {
        device = builtins.elemAt globals.corsair.drives 1;
        type = "disk";
        content = {
          type = "gpt";
          partitions = {
            luks = {
              size = "100%";
              content = {
                type = "luks";
                name = "second_crypted";
                passwordFile = "/tmp/luks_password";
                extraFormatArgs = [ "--pbkdf argon2id" ];
                extraOpenArgs = [ "--allow-discards" ];
                content = {
                  type = "lvm_pv";
                  vg = "${globals.meta.lvmPool}";
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
          ${globals.meta.lvmLogicalSystem} = {
            size = "87%VG";
            content = {
              type = "btrfs";
              extraArgs = [ "-f" ];
              postCreateHook = ''
                TMP=$(mktemp -d);
                mount -t btrfs -o subvol=root "/dev/${globals.meta.lvmPool}/${globals.meta.lvmLogicalSystem}" "$TMP";
                mkdir -p "$TMP"/{persist,nix,root,.snapshots,.swapvol,.vm};
                mount -t btrfs -o subvol=snapshots "/dev/${globals.meta.lvmPool}/${globals.meta.lvmLogicalSystem}" "$TMP/.snapshots";
                trap 'umount -A $TMP; rm -rf $TMP' EXIT;
                btrfs subvolume snapshot -r "$TMP" "$TMP/.snapshots/blank-root";
              '';
              postMountHook = ''
                mkdir -p /mnt${globals.meta.persistFlakePath};
                mkdir -p /mnt/persist/system/var/lib/sops-nix
                mkdir -p /mnt/persist/system/etc/ssh
                for filename in /tmp/*; do
                  if printf '%s' "$filename" | grep -q ${isConfig}.age; then
                    cp "$filename" /mnt/persist/system/var/lib/sops-nix
                  elif printf '%s' "$filename" | grep -q ${isConfig}_ed25519_key; then
                    cp "$filename" /mnt/persist/system/etc/ssh
                  fi
                done
                chmod 0600 "/mnt/persist/system/var/lib/sops-nix/${isConfig}.age"
                trap 'rm -rf /tmp/luks_password;' EXIT;
                cp -r /dotfiles/* /mnt${globals.meta.persistFlakePath};
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
                "/snapshots" = {
                  mountpoint = "/.snapshots";
                  mountOptions = [ "subvol=snapshots" "compress=zstd" "noatime" ];
                };
                "/swap" = {
                  mountpoint = "/.swapvol";
                  swap.swapfile.size = "4G";
                }; 
              };
            };
          };
          vm = {
            size = "100%FREE";
            content = {
              type = "filesystem";
              format = "ntfs";
              mountpoint = "/.vm";
              extraArgs = [ "-f" ];
              mountOptions = [ "defaults" ];
            };
          };
        };
      };
    };
  };
}
