{ config
, isUser
, lib
, ...
}:{
  options = {
    custom.retrodeck = {
      enable = lib.mkEnableOption "RetroDECK config";
    };
  };

  config = lib.mkIf config.custom.retrodeck.enable {
    home-manager.users.${isUser} = {
      services.flatpak = {
        packages = [
          {
            appId = "net.retrodeck.retrodeck";
            origin = "flathub";
          }
        ];
		overrides = {
          "net.retrodeck.retrodeck" = {
            Context = {
              filesystems = [
                "~/Games:rw"
                "!~/.steam"
                "!xdg-data/Steam"
              ];
            };
          };
        };
      };
    };
    
    environment.persistence."/persist" = {
      users.${isUser} = {
        directories = [
          ".var/app/net.retrodeck.retrodeck"
        ];
      };
    };
  };
}
