{ drives ? "Set this to storage drives, such as /dev/sda. Pass as arguments to disko when formating"
, inputs
, globals
, pkgs
, ...
}:{
  imports = [
    inputs.disko.nixosModules.default
  ];

  disko.devices = {
    disk = {
      main = {
        device = builtins.elemAt drives 0; #change implementation?
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
                  vg = "pool";
                };
              };
            };
          };
        };
      };
      secondary = {
        device = builtins.elemAt drives 1;
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
            size = "66%VG";
            content = {
              type = "btrfs";
              extraArgs = [ "-f" ];
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
              };
            };
          };
          vm = {
            size = "14%VG";
            content = {
              type = "filesystem";
              format = "ntfs";
              mountpoint = "/.vm";
              extraArgs = [];
              mountOptions = [];
            };
          };
          storage = {
            size = "100%FREE";
            content = {
              type = "btrfs";
              extraArgs = [ "-f" ];
              postCreateHook = ''
                TMP=$(mktemp -d);
                mount -t btrfs -o subvol=root "/dev/pool/system" "$TMP";
                mkdir -p $TMP/{persist,nix,root,.snapshots,.swapvol,.vm};
                mount -t btrfs -o subvol=snapshots "/dev/pool/system" "$TMP/.snapshots";
                trap 'umount -A $TMP; rm -rf $TMP' EXIT;
                btrfs subvolume snapshot -r "$TMP" "$TMP/.snapshots/blank-root";
              '';
              postMountHook = ''
                mkdir -p /mnt/persist/system/etc/nixos;
                mkdir -p /mnt/persist/system/var/lib/sops-nix
                cp /tmp/usb/data/secrets/keys.txt /mnt/persist/system/var/lib/sops-nix/
                chmod 0600 /mnt/persist/system/var/lib/sops-nix/keys.txt
                trap 'rm -rf /tmp/luks_password;' EXIT;
                cp -r /dotfiles /mnt/persist/system/etc/nixos;
              '';
              subvolumes = {
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
