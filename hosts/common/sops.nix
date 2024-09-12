{ pkgs
, inputs
, ...
}:{
  imports = [
    inputs.sops-nix.nixosModules.sops
  ];

  security.pam.services = {
    sops.text = ''
      session optional pam_exec.so expose_authtok export SOPS_AGE_KEY=$(echo $PAM_AUTH_TOK | ${pkgs.keepassxc}/bin/keepassxc-cli attachment-export --stdout "/persist/home/Drive/Apps/KeePassXC/test.kdbx" "Age Keys" "keys.txt");
    '';
  };

  #environment.sessionVariables = {
  #  "SOPS_AGE_KEY" = "$(${pkgs.keepassxc}/bin/keepassxc-cli attachment-export --stdout \"/persist/home/Drive/Apps/KeePassXC/test.kdbx\" \"Age Keys\" \"keys.txt\")";
  #};

  sops = {
    defaultSopsFile = ./secrets/secrets.yaml;
    defaultSopsFormat = "yaml";
    environment = {
      "SOPS_AGE_KEY_FILE" = "/tmp/usb/data/secrets/keys.txt";
    };
    #age = {
    #  sshKeyPaths = map (x: x.path) config.services.openssh.hostKeys;
    #  keyFile = "/persist/system/var/lib/sops.nix/keys.txt";
    #  generateKey = true;
    #};
  };
}
