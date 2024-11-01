{ config
, isUser
, lib
, ...
}:{
  options = {
    custom.obsidian = {
      enable = lib.mkEnableOption "Obsidian.md config";
    };
  };

  config = lib.mkIf config.custom.obsidian.enable {
    home-manager.users.${isUser} = {
      services.flatpak = {
        packages = [
          {
            appId = "md.obsidian.Obsidian";
	    origin = "flathub";
	  }
	];
      };
    };

    environment.persistence."/persist" = {
      users.${isUser} = {
        directories = [
          ".var/app/md.obsidian.Obsidian"
        ];
      };
    };
  };
}
