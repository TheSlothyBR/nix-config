{ config
, isUser
, lib
, ...
}:{
  options = {
    custom.onlyoffice = {
      enable = lib.mkEnableOption "OnlyOffice config";
    };
  };

  config = lib.mkIf config.custom.onlyoffice.enable {
    home-manager.users.${isUser} = {
      services.flatpak = {
        packages = [
          {
            appId = "org.onlyoffice.desktopeditors";
            origin = "flathub";
          }
        ];
        overrides = {
          "org.onlyoffice.desktopeditors" = {
            Context = {
              sockets = [
                "!wayland"
                "x11"
                "fallback-x11"
              ];
            };
          };
        };
      };
    };

    environment.persistence."/persist" = {
      users.${isUser} = {
        directories = [
          ".var/app/org.onlyoffice.desktopeditors"
        ];
      };
    };
  };
}
