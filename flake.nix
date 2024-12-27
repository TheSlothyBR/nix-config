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
      url = "github:danth/stylix/release-24.11";
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
    kvlibadwaita = {
      url = "github:MOIS3Y/KvLibadwaita";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-flatpak = {
      url = "github:gmodena/nix-flatpak";
    };
    sops-nix = {
      url = "github:mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    umu = {
      url = "github:Open-Wine-Components/umu-launcher?dir=packaging/nix";
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
        runtimeInputs = with pkgs; [ age git sops ssh-to-age ];
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
          mount ${globals.meta.usb} /tmp/usb
          
          modprobe zram
          zramctl /dev/zram0 --algorithm zstd --size "$(grep MemTotal /proc/meminfo | tr -dc '0-9')KiB"
          mkswap -U clear /dev/zram0
          swapon --discard --priority 150 /dev/zram0
          mount -o remount,size=6G,noatime /nix/.rw-store
          
          touch /tmp/luks_password

          nix --experimental-features 'nix-command flakes' shell nixpkgs#git -c git clone https://github.com/${globals.meta.owner}/${globals.meta.repo}.git /dotfiles && cd /dotfiles
          
          #lib.custom.getSetValuesList globals [ "hostName" ] [ "meta" ]
          configs=(
            ${globals.ultra.hostName}
            ${globals.corsair.hostName}
          )

          NO_INSTALL=1
          CORES=0
          JOBS=1

          if [[ $# -eq 0 ]]; then
            echo "Provide a Nix Flake config name, check script for options"
            exit 1
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

          if [ ! -f "/dotfiles/flake.lock" ]; then
            echo "Error: no placeholder flake.lock file found"
            exit 1
          fi

          if [ ! -f "/dotfiles/hosts/''${FLAKE}/system/hardware-configuration.nix" ]; then
            echo "Error: no placeholder hardware-configuration.nix file found"
            exit 1
          fi

          if [ ! -f "/dotfiles/hosts/''${FLAKE}/system/secrets/secrets.yaml" ]; then
            echo "Error: no placeholder secrets.yaml file found"
            exit 1
          fi

          export SOPS_AGE_KEY_FILE=/tmp/usb/data/secrets/keys.age

          if grep -e "\s*-\s&''${FLAKE}\sage[0-9a-zA-Z]{59}$" "/dotfiles/.sops.yaml"; then
            cp "/tmp/usb/data/secrets/''${FLAKE}.age" "/tmp/''${FLAKE}.age"
            SOPS_AGE_KEY_FILE=/tmp/''${FLAKE}.age
            sops -d --extract "[\"''${FLAKE}\"][\"luks\"]" "/dotfiles/hosts/''${FLAKE}/system/secrets/secrets.yaml" > /tmp/luks_password
          else
            ssh-keygen -t ed25519 -f "/tmp/''${FLAKE}_ed25519_key" -N ""
            ssh-to-age -private-key -i "/tmp/''${FLAKE}_ed25519_key" > "/tmp/''${FLAKE}.age"
            age-keygen -y -o "/tmp/''${FLAKE}_pub.age" "/tmp/''${FLAKE}.age"
            SOPS_AGE_KEY_FILE=/tmp/''${FLAKE}.age
            if [ ! -f "/dotfiles/hosts/''${FLAKE}/system/secrets/secrets.yaml" ]; then
              sed -i -e "s@[[:space:]]*-[[:space:]]\&''${FLAKE}[[:space:]]*@    - \&''${FLAKE} $(cat "/tmp/''${FLAKE}_pub.age")@g" /dotfiles/.sops.yaml
              read -rs -p "LUKS and Login Password: " PASS
              touch /tmp/luks_password
              printf '%s' "$PASS" > /tmp/luks_password
              cat << 'EOF' > "/dotfiles/hosts/''${FLAKE}/system/secrets/secrets.yaml"
''${FLAKE}:
    password: $(mkpasswd "$PASS")
    luks: $PASS
EOF
              sops -e -i "/dotfiles/hosts/''${FLAKE}/system/secrets/secrets.yaml"
              unset PASS
            else
              sed -i -e "s@[[:space:]]*-[[:space:]]\&''${FLAKE}[[:space:]]*@    - \&''${FLAKE} $(cat "/tmp/''${FLAKE}_pub.age")@g" /dotfiles/.sops.yaml
              sops updatekeys -y "/dotfiles/hosts/''${FLAKE}/system/secrets/secrets.yaml"
              sops -d --extract "[\"''${FLAKE}\"][\"luks\"]" "/dotfiles/hosts/''${FLAKE}/system/secrets/secrets.yaml" > /tmp/luks_password
            fi
          fi
          
          for config in "''${configs[@]}"; do
            if [[ "$config" == "$FLAKE" ]]; then
          
                if grep -q "{}" "/dotfiles/hosts/''${config}/system/hardware-configuration.nix"; then
                  nixos-generate-config --no-filesystems --root /mnt --show-hardware-config > "/dotfiles/hosts/''${config}/system/hardware-configuration.nix"
                fi
          
              if [[ NO_INSTALL -eq 0 ]]; then
                nix --experimental-features 'nix-command flakes' run github:nix-community/disko --no-write-lock-file -- --mode disko --flake "/dotfiles#''${config}"
                exit
              elif [[ ! CORES -eq 0 ]] || [[ ! JOBS -eq 1 ]]; then
                nix --experimental-features 'nix-command flakes' run github:nix-community/disko --no-write-lock-file -- --mode disko --flake "/dotfiles#''${config}"
                nixos-install --cores "$CORES" --max-jobs "$JOBS" --root /mnt --no-root-password --flake "/dotfiles#''${config}"
                exit
              else
                nix --experimental-features 'nix-command flakes' run github:nix-community/disko --no-write-lock-file -- --mode disko --flake "/dotfiles#''${config}"
                nixos-install --root /mnt --no-root-password --flake "/dotfiles#''${config}"
                exit
              fi
          
            else
              echo "Error: unknown configuration provided"
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
