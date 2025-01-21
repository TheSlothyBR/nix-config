{
  config,
  isUser,
  lib,
  ...
}:
{
  options = {
    custom.heroic-games = {
      enable = lib.mkEnableOption "Heroic Games Launcher config";
    };
  };

  config = lib.mkIf config.custom.heroic-games.enable {
    home-manager.users.${isUser} = {
      services.flatpak = {
        packages = [
          {
            appId = "com.heroicgameslauncher.hgl";
            origin = "flathub";
          }
        ];
        overrides = {
          "com.heroicgameslauncher.hgl" = {
            Context = {
              sockets = [
                "wayland"
                #"x11"
              ];
            };
          };
        };
      };
    };

    environment.persistence."/persist" = {
      users.${isUser} = {
        directories = [
          ".var/app/com.heroicgameslauncher.hgl"
        ];
      };
    };
  };
}
