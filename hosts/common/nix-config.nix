{ inputs
, config
, lib
, ...
}:{
  options = {
    custom.nix-config = {
      enable = lib.mkEnableOption "Nix config";
      allowUnfree = lib.mkEnableOption "Unfree nixpkgs";
    };
  };

  config = lib.mkIf config.custom.nix-config.enable {
    nix = {
      nixPath = [ "nixpkgs=${inputs.nixpkgs}" ];
      settings = {
        auto-optimise-store = true;
        experimental-features = [
          "nix-command"
          "flakes"
          "pipe-operators"
        ];
        trusted-users = [
          "root"
          "@wheel"
        ];
      };
      gc = {
        automatic = true;
        dates = "daily";
        options = "--delete-older-than 2d";
      };
    };

    nixpkgs = {
      config = {
        allowUnfree = config.custom.nix-config.allowUnfree;
      };
    };
  };
}
