{ outputs
, config
, pkgs
, lib
, isUser
, isConfig
, ...
}:let
  hosts = builtins.filter (x: ! (x == "customIso")) (lib.attrNames outputs.nixosConfigurations);
in {
  options = {
    custom.ssh = {
      enable = lib.mkEnableOption "ssh config";
    };
  };

  config = lib.mkIf config.custom.ssh.enable {
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
      #    path = "/persist/system/etc/ssh/${isConfig}_ed25519_key";
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

    home-manager.users.${isUser} = {
      home.file."/home/${isUser}/.config/environment.d/ssh-agent.conf".text = ''
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
        ln -sf /home/${isUser}/.ssh/known_hosts /etc/ssh/ssh_known_hosts
      '';
    };

    environment.persistence."/persist" = {
      users.${isUser} = {
        directories = [
          { directory = ".ssh"; mode = "0700"; }
        ];
      };
    };
  };
}
