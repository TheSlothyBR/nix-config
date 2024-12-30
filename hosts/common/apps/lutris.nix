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
                "x11"
              ];
              filesystems = [
                "~/Games"
				"~/.var/app/com.valvesoftware.Steam:ro"
              ];
            };
          };
        };
      };
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