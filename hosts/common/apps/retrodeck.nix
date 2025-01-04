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
