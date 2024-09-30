{ pkgs
, inputs
, config
, globals
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
  
  #home-manager = {
  #  sharedModules = [ 
  #    inputs.sops-nix.homeManagerModules.sops
  #  ];
  #  users.${globals.ultra.userName} = {
  #    sops = {
  #      defaultSopsFile = ./secrets/secrets.yaml;
  #      defaultSopsFormat = "yaml";
  #      age = {
  #        keyFile = "/persist/home/${globals.ultra.userName}/keys.txt";
  #      };
  #    };
  #  };
  #};
}
