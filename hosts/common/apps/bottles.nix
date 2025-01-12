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
        overrides = {
          "com.usebottles.bottles" = {
            Context = {
              sockets = [
                "wayland"
              ];
              filesystems = [
                "~/Games:rw"
              ];
            };
          };
        };
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
