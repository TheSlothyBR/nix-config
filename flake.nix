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
    globals = import ./globals.nix;
  in
  {
    nixosConfigurations = {
      "${globals.ultra.hostName}" = nixpkgs.lib.nixosSystem rec {
        nixpkgs.hostPlatform = "${globals.ultra.system}";
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
      customIso = nixpkgs.lib.nixosSystem rec {
        specialArgs = {
          inherit inputs globals;
        };
        modules = [
          ./hosts/customIso/configuration.nix
        ];
      };

      packages = let
        system = builtins.elemAt globals.architectures 0;
        pkgs = import nixpkgs { inherit system; };
      in {
          default = self.packages.${system}.install;

          install = pkgs.writeShellApplication {
            name = "install";
            runtimeInputs = with pkgs; [ git ];
            text = ''${./install.sh} "$@"'';
          };
        };
      apps = let
        system = builtins.elemAt globals.architectures 0;
      in {
        default = self.apps.${system}.install;

        install = {
          type = "app";
          program = "${self.packages.${system}.install}/bin/install";
        };
      };
    };
  };
}
