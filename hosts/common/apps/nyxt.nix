{ config
, isUser
, lib
, ...
}:{
  options = {
    custom.nyxt = {
      enable = lib.mkEnableOption "Nyxt Browser config";
    };
  };

  config = lib.mkIf config.custom.nyxt.enable {
    home-manager.users.${isUser} = {
      services.flatpak = {
        packages = [
          {
            appId = "engineer.atlas.Nyxt";
            origin = "flathub";
          }
        ];
      };
    };

    environment.persistence."/persist" = {
      users.${isUser} = {
        directories = [
          ".var/app/engineer.atlas.Nyxt"
        ];
      };
    };
  };
}
