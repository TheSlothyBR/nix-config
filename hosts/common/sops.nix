{ pkgs
, inputs
, ...
}:{
  imports = [
    inputs.sops-nix.nixosModules.sops
  ];

  environment.sessionVariables = {
    "SOPS_AGE_KEYS" = "$(${pkgs.keepassxc}/bin/keepassxc-cli attachment-export --stdout \"/persist/home/Drive/Apps/KeePassXC/test.kdbx\" \"Age Keys\" \"keys.txt\")";
  };

  sops = {
    defaultSopsFile = ./secrets/secrets.yaml;
    defaultSopsFormat = "yaml";
    #environment = {
    #  "SOPS_AGE_KEYS" = ''
    #    $(keepassxc-cli attachment-export --stdout "/persist/home/Drive/Apps/KeePassXC/s.kdbx" "Age Keys" "keys.txt")
    #  '';
    #};
    age = {
    #  sshKeyPaths = map (x: x.path) config.services.openssh.hostKeys;
      keyFile = "/persist/system//var/lib/sops.nix/keys.txt";
    #  generateKey = true;
    };
  };
}
