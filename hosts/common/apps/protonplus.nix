{ config
, isUser
, lib
, ...
}:{
  options = {
    custom.protonplus = {
      enable = lib.mkEnableOption "ProtonPlus compatibility tools config";
    };
  };

  config = lib.mkIf config.custom.protonplus.enable {
    home-manager.users.${isUser} = {
      services.flatpak = {
        packages = [
          {
            appId = "com.vysp3r.ProtonPlus";
            origin = "flathub";
          }
        ];
        overrides = {
          "com.vysp3r.ProtonPlus" = {
            Context = {
              filesystems = [
                "~/Games:rw"
                (if config.custom.steam.enable
                 then "~/.var/app/com.valvesoftware.Steam:rw"
                 else ""
                )
                (if config.custom.lutris.enable
                 then "~/.var/app/net.lutris.Lutris:rw"
                 else ""
                )
              ];
            };
          };
        };
      };
    };

    environment.persistence."/persist" = {
      users.${isUser} = {
        directories = [
          ".var/app/com.vysp3r.ProtonPlus"
        ];
      };
    };
  };
}
