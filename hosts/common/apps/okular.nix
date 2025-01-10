{ config
, isUser
, lib
, ...
}:{
  options = {
    custom.okular = {
      enable = lib.mkEnableOption "Okular config";
    };
  };

  config = lib.mkIf config.custom.okular.enable {
    home-manager.users.${isUser} = {
      services.flatpak = {
        packages = [
          {
            appId = "org.kde.okular";
            origin = "flathub";
          }
        ];
      };
    };

    environment.persistence."/persist" = {
      users.${isUser} = {
        directories = [
          ".var/app/org.kde.okular"
        ];
      };
    };
  };
}
