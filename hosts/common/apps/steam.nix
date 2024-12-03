{ config
, isUser
, lib
, ...
}:{
  options = {
    custom.steam = {
      enable = lib.mkEnableOption "Steam config";
    };
  };

  config = lib.mkIf config.custom.steam.enable {
    home-manager.users.${isUser} = {
      services.flatpak = {
        packages = [
          {
            appId = "com.valvesoftware.Steam";
            origin = "flathub";
          }
        ];
      };
    };

    environment.persistence."/persist" = {
      users.${isUser} = {
        directories = [
          ".var/app/com.valvesoftware.Steam"
        ];
      };
    };
  };
}
