{ config
, isUser
, lib
, ...
}:{
  options = {
    custom.vlc = {
      enable = lib.mkEnableOption "VLC config";
    };
  };

  config = lib.mkIf config.custom.vlc.enable {
    home-manager.users.${isUser} = {
      services.flatpak = {
        packages = [
          {
            appId = "org.videolan.VLC";
            origin = "flathub";
          }
        ];
        overrides = {
          "org.videolan.VLC" = {
            Context = {
              sockets = [
                "wayland"
                "x11"
              ];
            };
          };
        };
      };
    };

    environment.persistence."/persist" = {
      users.${isUser} = {
        directories = [
          ".var/app/org.videolan.VLC"
        ];
      };
    };
  };
}
