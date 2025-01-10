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
