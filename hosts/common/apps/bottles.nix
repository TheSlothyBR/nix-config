{ config
, isUser
, lib
, ...
}:{
  options = {
    custom.bottles = {
      enable = lib.mkEnableOption "Bottles config";
    };
  };

  config = lib.mkIf config.custom.bottles.enable {
    home-manager.users.${isUser} = {
      services.flatpak = {
        packages = [
          {
            appId = "com.usebottles.bottles";
            origin = "flathub";
          }
        ];
      };
    };

    environment.persistence."/persist" = {
      users.${isUser} = {
        directories = [
          ".var/app/com.usebottles.bottles"
        ];
      };
    };
  };
}
