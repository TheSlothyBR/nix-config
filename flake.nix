{
  description = "My multi-system nix config";

  inputs = {
    nixpkgs = {
      url = "github:nixos/nixpkgs/nixos-24.05";
    };
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    impermanence = {
      url = "github:nix-community/impermanence";
    };
    #lanzaboote = {
    #  url = "github:nix-community/lanzaboote";
    #  inputs.nixpkgs.follows = "nixpkgs";
    #};
    #system-manager = {
    #  url = "github:numtide/system-manager";
    #  inputs.nixpkgs.follows = "nixpkgs";
    #};
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    plasma-manager = {
      url = "github:pjones/plasma-manager";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        home-manager.follows = "home-manager";
      };
    };
    nix-flatpak.url = "github:gmodena/nix-flatpak";
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
  in
  rec
  {
    nixosConfigurations = {
      "${globals.ultra.hostName}" = nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit inputs outputs globals;
        };
        modules = [
          ./hosts/ultra/system/drives.nix
          ./hosts/ultra/system/impermanence.nix
          ./hosts/ultra/system/hardware-configuration.nix
          ./hosts/ultra/home/home.nix
          ./hosts/ultra/configuration.nix
        ];
      };
      customIso = nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit inputs globals;
        };
        modules = [
          ./hosts/customIso/configuration.nix
        ];
      };
    };

    packages = let
      system = builtins.elemAt globals.meta.architectures 0;
      pkgs = nixpkgs.legacyPackages."${system}";
    in {
        ${system}.install = pkgs.writeShellApplication {
          name = "install";
          runtimeInputs = with pkgs; [ git sops rclone ];
          text = ''
            #''${/dotfiles/pkgs/install.sh} "$@"
            mkdir -p /tmp/usb;
            mount "/dev/disk/by-id/usb-Kingston_DT_101_G2_0018F30CA1A8BD30F17B0199-0\:0-part1" "/tmp/usb";
            nix-shell -p git --command "git clone https://github.com/TheSlothyBR/nix-config /dotfiles && cd /dotfiles && git checkout structured"
            
            configs=(
              ultra
              corsair
            )
            
            NO_INSTALL=1
            CORES=0
            JOBS=1
            export SOPS_AGE_KEY_FILE=/tmp/usb/data/secrets/keys.txt
            
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
            	  shift # past argument
            	  shift # past value
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
            
            trap 'rm -rf /dotfiles; umount -A /tmp/usb' EXIT;
            
            for config in "''${configs[@]}"; do
            	if [[ "$config" == "$FLAKE" ]]; then
            
                  if grep -q "{}" "/dotfiles/hosts/''${config}/system/hardware-configuration.nix"; then
                    nixos-generate-config --no-filesystems --root /mnt --show-hardware-config > "/dotfiles/hosts/''${config}/system/hardware-configuration.nix"
                  fi
            
            	  if [[ NO_INSTALL -eq 0 ]]; then
            		nix --extra-experimental-features 'nix-command flakes' run github:nix-community/disko -- --mode disko --flake ".#''${config}"
            		exit
            	  elif [[ ! CORES -eq 0 ]] || [[ ! JOBS -eq 1 ]]; then
            		nix --extra-experimental-features 'nix-command flakes' run github:nix-community/disko -- --mode disko --flake ".#''${config}"
            		nixos-install --cores "$CORES" --max-jobs "$JOBS" --root /mnt --flake ".#''${config}"
                    #rclone copyto OneDrive:Apps/KeePassXC/s.kdbx /persist/home/Drive/Apps/KeePassXC/s.kdbx --config "/home/''${config}/.config/rclone/rclone.conf"
            		exit
            	  else
            		nix --extra-experimental-features 'nix-command flakes' run github:nix-community/disko -- --mode disko --flake ".#''${config}"
            		nixos-install --root /mnt --flake ".#''${config}"
                    #rclone copyto OneDrive:Apps/KeePassXC/s.kdbx /persist/home/Drive/Apps/KeePassXC/s.kdbx --config "/home/''${config}/.config/rclone/rclone.conf"
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
      default = {
        type = "app";
        program = "${self.packages.${system}.install}/bin/install";
      };
    };
  };
}
