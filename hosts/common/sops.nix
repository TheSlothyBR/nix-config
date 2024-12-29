{ pkgs
, inputs
, isConfig
, config
, lib
, ...
}:{
  imports = [
    inputs.sops-nix.nixosModules.sops
  ];

  options = {
    custom.sops = {
      enable = lib.mkEnableOption "Sops-nix config";
    };
  };

  config = lib.mkIf config.custom.sops.enable {
    sops = {
      defaultSopsFile = ./secrets/secrets.yaml;
      defaultSopsFormat = "yaml";
      age = {
        keyFile = "/persist/system/var/lib/sops-nix/${isConfig}.age";
      };
    };

    environment.sessionVariables = {
      SOPS_AGE_KEY_FILE = "${config.sops.age.keyFile}";
    };
  };
}
