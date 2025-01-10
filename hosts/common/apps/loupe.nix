{ config
, isUser
, lib
, ...
}:{
  options = {
    custom.loupe = {
      enable = lib.mkEnableOption "GNOME Image Viewer (Loupe) config";
    };
  };

  config = lib.mkIf config.custom.loupe.enable {
    home-manager.users.${isUser} = {
      services.flatpak = {
        packages = [
          {
            appId = "org.gnome.Loupe";
            origin = "flathub";
          }
        ];
      };
    };

    environment.persistence."/persist" = {
      users.${isUser} = {
        directories = [
          ".var/app/org.gnome.Loupe"
        ];
      };
    };
  };
}
