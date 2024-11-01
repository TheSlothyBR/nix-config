{ config
, isUser
, lib
, ...
}:{
  options = {
    custom.stremio = {
      enable = lib.mkEnableOption "Stremio config";
    };
  };

  config = lib.mkIf config.custom.stremio.enable {
    home-manager.users.${isUser} = {
      services.flatpak = {
        packages = [
          {
            appId = "com.stremio.Stremio";
            origin = "flathub";
          }
        ];
      };
    };
    environment.persistence."/persist" = {
      users.${isUser} = {
        directories = [
          ".var/app/com.stremio.Stremio"
        ];
      };
    };
  };
}
