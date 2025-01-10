{ config
, isUser
, lib
, ...
}:{
  options = {
    custom.scribus = {
      enable = lib.mkEnableOption "Scribus config";
    };
  };

  config = lib.mkIf config.custom.scribus.enable {
    home-manager.users.${isUser} = {
      services.flatpak = {
        packages = [
          {
            appId = "net.scribus.Scribus";
            origin = "flathub";
          }
        ];
      };
    };

    environment.persistence."/persist" = {
      users.${isUser} = {
        directories = [
          ".var/app/net.scribus.Scribus"
        ];
      };
    };
  };
}
