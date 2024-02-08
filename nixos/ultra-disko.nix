{ device ? "Set this to storage device, such as /dev/sda. Pass as argument to Disko when formating" }: {
disko.devices = {
  disk.main = {
    inherit device;
    type = "disk";
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
          size = "100%";
    	  content = {
            type = "luks";
    		name = "ultra_crypted";
    		extraOpenArgs = [ ];
    		content = {
              type = "lvm_pv";
    		  vg = "pool";
    		};
    	  };
        };
      };
    };
    lvm_vg = {
      pool = {
        type = "lvm_vg";
		lvs = {
          root = {
		    size = "100%FREE";
			content = {
			  type = "btrfs";
			  extraArgs = [ "-f" ];
			  subvolumes = {
			    "/root" = {
				  mountpoint = "/";
				  mountOptions = [ "compress=zstd" ];
				};
                "/swap" = {
                  mountpoint = "/.swapvol";
                  swap.swapfile.size = "4G";
                };
				"/persist" = {
				  mountpoint = "/persist";
				  mountOptions = [ "subvol=persist" "compress=zstd" "noatime" ];
				};
				"/nix" = {
				  mountpoint = "/nix";
				  mountOptions = [ "subvol=nix" "compress=zstd" "noatime" ];
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
};
