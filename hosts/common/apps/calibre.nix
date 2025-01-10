{ config
, isUser
, lib
, ...
}:{
  options = {
    custom.calibre = {
      enable = lib.mkEnableOption "Calibre config";
    };
  };

  config = lib.mkIf config.custom.calibre.enable {
    home-manager.users.${isUser} = {
      services.flatpak = {
        packages = [
          {
            appId = "com.calibre_ebook.calibre";
            origin = "flathub";
          }
        ];
        overrides = {
          "com.calibre_ebook.calibre" = {
            Context = {
              filesystems = [
                "~/Drive/CalibreLibrary:rw"
              ];
            };
          };
        };
      };
    };

    environment.persistence."/persist" = {
      users.${isUser} = {
        directories = [
          ".var/app/com.calibre_ebook.calibre"
        ];
      };
    };
  };
}
