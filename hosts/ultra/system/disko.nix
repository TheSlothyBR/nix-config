{
  drives ? "Set this to storage drives, such as /dev/sda. Pass as arguments to disko when formating"
, globals
, ...
}: {
  disko.devices = {
    disk = {
      main = {
        device = builtins.alemAt drives 0;
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
                askPassword = true;
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
                mount -t btrfs -o subvol=/ "/dev/mapper/pool-system" "$TMP";
                trap 'umount $TMP; rm -rf $TMP' EXIT;
                btrfs subvolume snapshot -r $TMP /mnt/.snapshots/blank-root;
              '';
              postMountHook = ''
                mkdir -p /mnt/persist/system/etc/nixos;
                cp -r ${globals.configRoot} /mnt/persist/system/etc/nixos;
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
                  mountOptions = [ "compress=zstd" "noatime" ];
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
