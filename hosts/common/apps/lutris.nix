{ config
, isUser
, lib
, ...
}:{
  options = {
    custom.lutris = {
      enable = lib.mkEnableOption "Lutris config";
    };
  };

  config = lib.mkIf config.custom.lutris.enable {
    home-manager.users.${isUser} = {
      services.flatpak = {
        packages = [
          {
            appId = "net.lutris.Lutris";
            origin = "flathub";
          }
        ];
        overrides = {
          "net.lutris.Lutris" = {
            Context = {
              sockets = [
                "wayland"
              ];
              filesystems = [
                "!home"
                "~/Games"
                "~/.steam"
              ];
            };
          };
        };
      };
    };

    systemd.services."lutris-steam-link" = {
      description = "Creates symlink for Lutris to use Steam flatpak";
      wantedBy = [ "multi-user.target" ];
      after = [ "sops-nix.service" ];
      serviceConfig.Type = "oneshot";
      script = ''
        ln -sf /home/${isUser}/.var/apps/com.valvesoftware.Steam/.steam /home/${isUser}/.steam
      '';
    };

    environment.persistence."/persist" = {
      users.${isUser} = {
        directories = [
          ".var/app/net.lutris.Lutris"
        ];
      };
    };
  };
}
