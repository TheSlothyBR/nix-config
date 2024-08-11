{ inputs
, globals
, config
, ...
}:{
  imports = [
    inputs.sops-nix.nixosModules.sops
  ];

  sops = {
    defaultSopsFile = ./secrets/secrets.yaml;
    defaultSopsFormat = "yaml";
   # environment = {
   #   "SOPS_AGE_KEYS" = "$(keepassxc-cli attachment-export)";
   # };
   age = {
     sshKeyPaths = config.services.openssh.hostKeys;
   };
  };
}
