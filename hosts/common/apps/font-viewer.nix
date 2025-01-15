{ config
, isUser
, lib
, ...
}:{
  options = {
    custom.font-viewer = {
      enable = lib.mkEnableOption "GNOME Fonts config";
    };
  };

  config = lib.mkIf config.custom.font-viewer.enable {
    home-manager.users.${isUser} = {
      services.flatpak = {
        packages = [
          {
            appId = "org.gnome.font-viewer";
            origin = "flathub";
          }
        ];
      };
    };

    environment.persistence."/persist" = {
      users.${isUser} = {
        directories = [
          ".var/app/org.gnome.font-viewer"
        ];
      };
    };
  };
}
