{ config
, isUser
, lib
, ...
}:{
  options = {
    custom.thunderbird = {
      enable = lib.mkEnableOption "Thunderbird config";
    };
  };

  config = lib.mkIf config.custom.thunderbird.enable {
    home-manager.users.${isUser} = {
      services.flatpak = {
        packages = [
          {
            appId = "org.mozilla.Thunderbird";
            origin = "flathub";
          }
        ];
        overrides = {
          "org.mozilla.Thunderbird" = {
            Context = {
              filesystems = [
                "~/Drive/Apps/Thunderbird:rw"
              ];
            };
          };
        };
      };
    };

    environment.persistence."/persist" = {
      users.${isUser} = {
        directories = [
          ".var/app/org.mozilla.Thunderbird"
        ];
      };
    };
  };
}
