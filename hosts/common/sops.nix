{ pkgs
, inputs
, ...
}:{
  imports = [
    inputs.sops-nix.nixosModules.sops
  ];

  sops = {
    defaultSopsFile = ./secrets/secrets.yaml;
    defaultSopsFormat = "yaml";
    age = {
      sshKeyPaths = map (x: x.path) config.services.openssh.hostKeys;
      keyFile = "/persist/system/var/lib/sops-nix/keys.txt";
      generateKey = true;
    };
  };
}
