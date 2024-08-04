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
  };

  outputs =
  { nixpkgs
  , ...
  } @inputs: let
    globals = import ./globals.nix;
  in
  {
    nixosConfigurations = {
      "${globals.ultra.hostName}" = nixpkgs.lib.nixosSystem rec {
        system = "${globals.ultra.system}";
        specialArgs = {
          inherit inputs globals;
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
          inherit inputs;
        };
        modules = [
          ./hosts/customIso/configuration.nix
        ];
      };
    };
  };
}
