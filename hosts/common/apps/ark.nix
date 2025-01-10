{ config
, isUser
, lib
, ...
}:{
  options = {
    custom.ark = {
      enable = lib.mkEnableOption "Ark config";
    };
  };

  config = lib.mkIf config.custom.ark.enable {
    home-manager.users.${isUser} = {
      services.flatpak = {
        packages = [
          {
            appId = "org.kde.ark";
            origin = "flathub";
          }
        ];
      };
    };

    environment.persistence."/persist" = {
      users.${isUser} = {
        directories = [
          ".var/app/org.kde.ark"
        ];
      };
    };
  };
}
