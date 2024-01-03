{ ... }: {
  disko.devices = {
    disk = {
      sda = { # name of attr set can be anything, name for drive for convenience 
        type = "disk";
        device = "/dev/sda"; # can also be declared from the "disks" attr with "builtins.elemAt disks 0;"
        content = {
          type = "gpt";
          partitions = {
            ESP = {
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
              start = "512MiB";
              end = "100%";
              content = {
                name = "ultra_crypted";
                type = "luks";
			    askPassword = true;
				settings.allowDiscards = true;
				content = {
                  type = "btrfs";
                  extraArgs = [ "-f" ]; # Override existing partition
                  postCreateHook = ''
                    btrfs subvolume snapshot -r /mnt/@root /mnt/@snapshots/@root-blank
                  '';
                  subvolumes = {
                    "@persist" = {
                      mountpoint = "/persist";
                      mountOptions = [ "compress=zstd" "noatime" ];
                    };
                    "@swap" = {
                      mountpoint = "/.swapvol";
                      swap.swapfile.size = "4G";
                    };
                    "@root" = {
                      mountpoint = "/";
                      mountOptions = [ "compress=zstd" "noatime" ];
                    };
                    "@snapshots" = {
					  mountpoint = "/.snapshots";
                      mountOptions = [ "compress=zstd" "noatime" ];
                    };
                    "@home" = {
                      mountpoint = "/home";
                      mountOptions = [ "compress=zstd" "noatime" ];
				    };
                  };
	            };
              };
            };
          };
        };
      };
    };
  };
}
