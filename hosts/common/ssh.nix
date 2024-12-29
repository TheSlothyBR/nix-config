{ outputs
, config
, pkgs
, lib
, isUser
, isConfig
, ...
}:{
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
    };
    
    programs.ssh = {
      startAgent = true;
    };

    home-manager.users.${isUser} = {
      home.file."/home/${isUser}/.config/environment.d/ssh-agent.conf".text = ''
SSH_AUTH_SOCK=$XDG_RUNTIME_DIR/ssh-agent
      '';
    };
    security.pam.sshAgentAuth = {
      enable = true;
      authorizedKeysFiles = [ "/etc/ssh/authorized_keys.d/%u" ];
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

    environment.persistence."/persist/system" = {
      hideMounts = true;
      directories = [
        "/etc/ssh"
      ];
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
