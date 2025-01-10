{ config
, isUser
, lib
, ...
}:{
  options = {
    custom.standardnotes = {
      enable = lib.mkEnableOption "Standard Notes config";
    };
  };

  config = lib.mkIf config.custom.standardnotes.enable {
    home-manager.users.${isUser} = {
      services.flatpak = {
        packages = [
          {
            appId = "org.standardnotes.standardnotes";
            origin = "flathub";
          }
        ];
        overrides = {
          "org.standardnotes.standardnotes" = {
            filesystems = [
              "~/Drive/Apps/standardnotes:rw"
            ];
          };
        };
      };
	};

    environment.persistence."/persist" = {
      users.${isUser} = {
        directories = [
          ".var/app/org.standardnotes.standardnotes"
        ];
      };
    };
  };
}
