{ drives ? "Set this to storage drives, such as /dev/sda. Pass as arguments to disko when formating"
, globals
, pkgs
, ...
}:{
  disko.devices = {
    disk = {
      main = {
        device = drives;
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
                #askPassword = true;
                settings.fallbackToPassword = true;
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
              preCreateHook = ''
                SOPS_AGE_KEY_FILE=/tmp/usb/data/secrets/keys.txt
                mkdir -p /tmp/usb;
                mount "/dev/disk/by-id/usb-Kingston_DT_101_G2_0018F30CA1A8BD30F17B0199-0\:0-part1" "/tmp/usb";
                touch /tmp/luks_password;
                ${pkgs.sops}/bin/sops -d --extract '["${globals.ultra.hostName}"]["luks"]' "/tmp/usb/data/secrets/secrets.yaml" > /tmp/luks_password
              '';
              postCreateHook = ''
                TMP=$(mktemp -d);
                mount -t btrfs -o subvol=root "/dev/pool/system" "$TMP";
                mkdir -p $TMP/{persist,nix,root,.snapshots,.swapvol};
                mount -t btrfs -o subvol=snapshots "/dev/pool/system" "$TMP/.snapshots";
                trap 'umount -A $TMP; rm -rf $TMP' EXIT;
                btrfs subvolume snapshot -r "$TMP" "$TMP/.snapshots/blank-root";
              '';
              postMountHook = ''
                mkdir -p /mnt/persist/system/etc/nixos;
                cp -r /nix-config /mnt/persist/system/etc/nixos;
                cp /tmp/usb/data/secrets/keys.txt /persist/home/.config/sops/age/keys.txt;
                trap 'umount -A /tmp/usb; rm -rf /tmp/luks_password;' EXIT;
                cp /tmp/usb/data/secrets/${globals.ultra.hostName}_ed25519_key /persist/system/etc/ssh/;
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
