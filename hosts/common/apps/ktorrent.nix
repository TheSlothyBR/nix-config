{ config
, isUser
, lib
, ...
}:{
  options = {
    custom.ktorrent = {
      enable = lib.mkEnableOption "KTorrent config";
    };
  };

  config = lib.mkIf config.custom.ktorrent.enable {
    home-manager.users.${isUser} = {
      services.flatpak = {
        packages = [
          {
            appId = "org.kde.ktorrent";
            origin = "flathub";
          }
        ];
      };
    };

    environment.persistence."/persist" = {
      users.${isUser} = {
        directories = [
          ".var/app/org.kde.ktorrent"
        ];
      };
    };
  };
}
