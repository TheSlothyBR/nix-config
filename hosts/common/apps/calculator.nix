{ config
, isUser
, lib
, ...
}:{
  options = {
    custom.calculator = {
      enable = lib.mkEnableOption "Calculator config";
    };
  };

  config = lib.mkIf config.custom.calculator.enable {
    home-manager.users.${isUser} = {
      services.flatpak = {
        packages = [
          {
            appId = "org.gnome.Calculator";
            origin = "flathub";
          }
        ];
      };
    };

    environment.persistence."/persist" = {
      users.${isUser} = {
        directories = [
          ".var/app/org.gnome.Calculator"
        ];
      };
    };
  };
}
