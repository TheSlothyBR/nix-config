{ pkgs
, inputs
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
        sshKeyPaths = map (x: x.path) config.services.openssh.hostKeys;
        keyFile = "/persist/system/var/lib/sops-nix/keys.txt";
        #generateKey = true;
      };
    };

    environment.sessionVariables = {
      SOPS_AGE_KEY_FILE = "${config.sops.age.keyFile}";
    };
  };
}
