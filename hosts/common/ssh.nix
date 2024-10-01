{ outputs
, pkgs
, lib
, globals
, ...
}:let
  hosts = builtins.filter (x: ! (x == "customIso")) (lib.attrNames outputs.nixosConfigurations);
in {
  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
      PermitRootLogin = "no";
      StreamLocalBindUnlink = "yes";
      GatewayPorts = "clientspecified";
      AcceptEnv = "WAYLAND_DISPLAY";
      X11Forwarding = true;
    };
    #hostKeys = [
    #  {
    #    path = "/persist/system/etc/ssh/${globals.ultra.hostName}_ed25519_key";
    #    type = "ed25519";
    #  }
    #];
  };
  
  programs.ssh = {
    startAgent = true;
    #knownHosts = lib.genAttrs hosts (hostname: {
    #  publicKeyFile = ./secrets/${hostname}_ed25519_key.pub;
    #});
  };

  home-manager.users.${globals.ultra.userName} = {
    home.file."/home/${globals.ultra.userName}/.config/environment.d/ssh-agent.conf".text = ''
SSH_AUTH_SOCK=$XDG_RUNTIME_DIR/ssh-agent
    '';
  };
  security.pam.sshAgentAuth = {
    enable = true;
    authorizedKeysFiles = ["/etc/ssh/authorized_keys.d/%u"];
  };

  systemd.services."link-ssh_known_hosts" = {
    description = "Creates symlink for root known hosts";
    wantedBy = [ "multi-user.target" ];
    after = [ "sops-nix.service" ];
    serviceConfig.Type = "oneshot";
    script = ''
      ln -sf /home/${globals.ultra.userName}/.ssh/known_hosts /etc/ssh/ssh_known_hosts
    '';
  };

  environment.persistence."/persist" = {
    users.${globals.ultra.userName} = {
      directories = [
        { directory = ".ssh"; mode = "0700"; }
      ];
    };
  };
}
