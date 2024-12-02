{
  description = "My multi-system nix config";

  inputs = {
    nixpkgs = {
      url = "github:nixos/nixpkgs/nixos-24.11";
    };
    nixpkgs-unstable = {
      url = "github:nixos/nixpkgs/nixos-unstable";
    };
    home-manager = {
      url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixvim = {
      url = "github:nix-community/nixvim/nixos-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    stylix = {
      url = "github:danth/stylix/release-24.05";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        home-manager.follows = "home-manager";
      };
    };
    nur = {
      url = "github:nix-community/NUR";
    };
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    impermanence = {
      url = "github:nix-community/impermanence";
    };
    lanzaboote = {
      url = "github:nix-community/lanzaboote";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    plasma-manager = {
      url = "github:pjones/plasma-manager";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        home-manager.follows = "home-manager";
      };
    };
    kwin-effects-forceblur = {
      url = "github:taj-ny/kwin-effects-forceblur";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-flatpak = {
      url = "github:gmodena/nix-flatpak";
    };
    sops-nix = {
      url = "github:mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
  { nixpkgs
  , self
  , ...
  } @inputs: let
    inherit (self) outputs;
    globals = import ./pkgs/globals.nix;
    lib = ((_: _.lib.extend (final: prev: (import ./lib final) // inputs.home-manager.lib)) inputs.nixpkgs);
  in
  rec
  {
    nixosConfigurations = lib.genAttrs 
    (lib.custom.getSetValuesList globals [ "hostName" ] [ "meta" ])
    (hostName:
      lib.nixosSystem {
        specialArgs = {
          inherit inputs outputs globals lib;
          isConfig = hostName;
          isUser = globals.${hostName}.userName;
	      };
        modules = [
          ./hosts/${hostName}/configuration.nix
	        ./overlays/unstable-pkgs-overlay.nix
	      ];
      }
    );

    packages = let
      system = builtins.elemAt globals.meta.architectures 0;
      pkgs = nixpkgs.legacyPackages."${system}";
    in {
      ${system}.install = pkgs.writeShellApplication {
        name = "install";
        runtimeInputs = with pkgs; [ git sops ];
        text = ''
          trap 'mount -o remount,size=2G,noatime /nix/.rw-store; \
                swapoff /dev/zram0; \
                modprobe -r zram; \
                echo 1 > /sys/module/zswap/parameters/enabled; \
                rm -rf /dotfiles; \
                umount -A /tmp/usb; \
                unset SOPS_AGE_KEY_FILE' \
          EXIT;
          mkdir -p /tmp/usb
          mount /dev/disk/by-id/usb-Kingston_DT_101_G2_0018F30CA1A8BD30F17B0199-0:0-part1 /tmp/usb
          
          modprobe zram
          zramctl /dev/zram0 --algorithm zstd --size "$(grep MemTotal /proc/meminfo | tr -dc '0-9')KiB"
          mkswap -U clear /dev/zram0
          swapon --discard --priority 150 /dev/zram0
          mount -o remount,size=6G,noatime /nix/.rw-store
          
          touch /tmp/luks_password
          nix-shell -p git --command "git clone https://github.com/TheSlothyBR/nix-config.git /dotfiles && cd /dotfiles"
          
          configs=(
            ultra
            corsair
          )

          NO_INSTALL=1
          CORES=0
          JOBS=1

          if [[ $# -eq 0 ]]; then
            echo "Provide a Nix Flake config name, check script for options"
            exit
          fi

          while [[ $# -gt 0 ]]; do
            case $1 in
          	-h|--help)
          	  echo "Provide a Nix Flake config name, check script for options"
          	  exit
          	  ;;
          	-f|--flake)
          	  FLAKE=$2
          	  shift
          	  shift
          	  ;;
          	--format-only)
          	  NO_INSTALL=0
          	  shift
          	  ;;
          	-c|--cores)
          	  CORES=$2
          	  shift
          	  shift
          	  ;;
          	-j|--max-jobs)
          	  JOBS=$2
          	  shift
          	  shift
          	  ;;
          	*)
          	  echo "Error: no known argument provided"
          	  exit 1
          	  ;;
            esac
          done

          if [[ $(find "/dotfiles/hosts/''${FLAKE}/system/" -mindepth 1 -maxdepth 1 -name "hardware-configuration.nix" | grep -q ".") -ne 0 ]]; then
            echo "Error: no placeholder hardware-configuration.nix file found"
            exit
          fi
          # Should probably check the existance of a lock file also
          
          export SOPS_AGE_KEY_FILE=/tmp/usb/data/secrets/keys.txt
          sops -d --extract "[\"''${FLAKE}\"][\"luks\"]" /dotfiles/hosts/common/secrets/secrets.yaml > /tmp/luks_password
          
          for config in "''${configs[@]}"; do
          	if [[ "$config" == "$FLAKE" ]]; then
          
                if grep -q "{}" "/dotfiles/hosts/''${config}/system/hardware-configuration.nix"; then
                  nixos-generate-config --no-filesystems --root /mnt --show-hardware-config > "/dotfiles/hosts/''${config}/system/hardware-configuration.nix"
                fi
          
          	  if [[ NO_INSTALL -eq 0 ]]; then
          		nix --experimental-features "nix-command flakes" run github:nix-community/disko --no-write-lock-file -- --mode disko --flake "/dotfiles#''${config}"
          		exit
          	  elif [[ ! CORES -eq 0 ]] || [[ ! JOBS -eq 1 ]]; then
          		nix --experimental-features "nix-command flakes" run github:nix-community/disko --no-write-lock-file -- --mode disko --flake "/dotfiles#''${config}"
                  nixos-install --cores "$CORES" --max-jobs "$JOBS" --root /mnt --no-root-password --flake "/dotfiles#''${config}"
          		exit
          	  else
          		nix --experimental-features "nix-command flakes" run github:nix-community/disko --no-write-lock-file -- --mode disko --flake "/dotfiles#''${config}"
                  nixos-install --root /mnt --no-root-password --flake "/dotfiles#''${config}"
                  exit
          	  fi
          
          	else
          	  echo "Error: unknown configuration provided"
          	  exit 1
          	fi
          done
        '';
      };
    };

    apps = let
      system = builtins.elemAt globals.meta.architectures 0;
    in {
      ${system} = {
        default = self.apps.${system}.install;

        install = {
          type = "app";
          program = "${self.packages.${system}.install}/bin/install";
        };
      };
    };
  };
}
