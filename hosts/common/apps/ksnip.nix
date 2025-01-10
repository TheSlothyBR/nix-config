{ config
, isUser
, lib
, ...
}:{
  options = {
    custom.ksnip = {
      enable = lib.mkEnableOption "Ksnip config";
    };
  };

  config = lib.mkIf config.custom.ksnip.enable {
    home-manager.users.${isUser} = {
      services.flatpak = {
        packages = [
          {
            appId = "org.ksnip.ksnip";
            origin = "flathub";
          }
        ];
      };
    };

    environment.persistence."/persist" = {
      users.${isUser} = {
        directories = [
          ".var/app/org.ksnip.ksnip"
        ];
      };
    };
  };
}
