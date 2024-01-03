{
  #nix flake lock --update-input nixpkgs
  #sudo nixos-rebuild switch --flake ~/.dotfiles#myNixos
  description = "My Nix agnostic system configuration";

  inputs = {
    nixpkgs = {
      url = "github:nixos/nixpkgs/nixos-23.11";
    };
    disko = {
      url = "github:nix-community/disko";
	  inputs.nixpkgs.follows = "nixpkgs";
    };
    #flake-utils = {
    #  url = "github:numtide/flake-utils";
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
  };

  outputs = { nixpkgs, ... }@inputs:{
    nixosConfigurations = {
      ultra = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs; };
        modules = [
          ./nixos/configuration.nix
		  disko.nixosModules.disko
		];
      };
    };
  };
}
