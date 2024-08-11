{ outputs
, ...
}:let
  hosts = builtins.filter (x:x != "customIso" || "packages" || "apps" ) (lib.attrNames outputs.nixosConfigurations);
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

   hostKeys = [
      {
        path = "/persist/system/etc/ssh/<privateKeyName>";
        type = "ed25519";
      }
    ];
  };

  programs.ssh = {
    knownHosts = lib.genAttrs hosts  (hostname: {
      publicKeyFile = "/persist/system/etc/nixos/dotfiles/common/secrets/<${hostname}keyName>.pub";
    });
  };
  
  security = {
    pam.services.sudo = {config, ...}: {
      rules.auth.rssh = {
        order = config.rules.auth.ssh_agent_auth.order - 1;
        control = "sufficient";
        modulePath = "${pkgs.pam_rssh}/lib/libpam_rssh.so";
        settings.authorized_keys_command =
          pkgs.writeShellScript "get-authorized-keys"
          ''
            cat "/etc/ssh/authorized_keys.d/$1"
          '';
      };
    };
    sudo.extraConfig = ''
      Defaults env_keep+=SSH_AUTH_SOCK
    '';
  };
}
