{ 
   drives ? "Set this to storage drives, such as /dev/sda. Pass as argument to disko when formating"
 , ...
}: {
  disko.devices = {
    disk = {
	  main = {
	    device = builtins.elemAt drives 0;
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
              };
            };
          };
          storage = {
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