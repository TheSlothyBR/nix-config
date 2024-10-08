{ inputs
, nixpkgs
, config
, lib
, ...
}:{
  imports = [
    inputs.lanzaboote.nixosModules.lanzaboote
  ];

  options = {
    custom.lanzaboote = {
      enable = lib.mkEnableOption "Nix-managed SecureBoot";
    };
  };

  config = lib.mkIf config.custom.lanzaboote.enable {
    boot = {
      loader.systemd-boot.enable = lib.mkForce false;
      lanzaboote = {
        enable = true;
        pkiBundle = "/etc/secureboot";
      };
    };
  };
}
