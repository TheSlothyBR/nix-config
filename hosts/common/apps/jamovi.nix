{ config
, isUser
, lib
, ...
}:{
  options = {
    custom.jamovi = {
      enable = lib.mkEnableOption "Jamovi config";
    };
  };

  config = lib.mkIf config.custom.jamovi.enable {
    home-manager.users.${isUser} = {
      services.flatpak = {
        packages = [
          {
            appId = "org.jamovi.jamovi";
            origin = "flathub";
          }
        ];
      };
    };

    environment.persistence."/persist" = {
      users.${isUser} = {
        directories = [
          ".var/app/org.jamovi.jamovi"
        ];
      };
    };
  };
}
