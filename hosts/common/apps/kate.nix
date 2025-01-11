{ config
, isUser
, lib
, ...
}:{
  options = {
    custom.kate = {
      enable = lib.mkEnableOption "Kate config";
    };
  };

  config = lib.mkIf config.custom.kate.enable {
    home-manager.users.${isUser} = {
      services.flatpak = {
        packages = [
          {
            appId = "org.kde.kate";
            origin = "flathub";
          }
        ];
      };
    };

    environment.persistence."/persist" = {
      users.${isUser} = {
        directories = [
          ".var/app/org.kde.kate"
        ];
      };
    };
  };
}
