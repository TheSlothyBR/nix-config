{ inputs
, config
, ...
}:{
  imports = [
    inputs.sops-nix.nixosModules.sops
  ];

  sops = {
    defaultSopsFile = ./secrets/secrets.yaml;
    defaultSopsFormat = "yaml";
    environment = {
      "SOPS_AGE_KEYS" = "$(keepassxc-cli attachment-export --stdout "/persist/home/Drive/Apps/KeePassXC/s.kdbx" "Age Keys" "keys.txt")";
    };
    #age = {
    #  sshKeyPaths = map (x: x.path) config.services.openssh.hostKeys;
    #  keyFile = "/var/lib/sops.nix/key.txt";
    #  generateKey = true;
    #};
  };
}
