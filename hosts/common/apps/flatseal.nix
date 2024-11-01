{ inputs
, config
, isUser
, lib
, ...
}:{
  options = {
    custom.flatseal = {
      enable = lib.mkEnableOption "Flatseal config";
    };
  };

  config = lib.mkIf config.custom.flatseal.enable {
    home-manager.users.${isUser} = {
      services.flatpak = {
        packages = [
          {
            appId = "com.github.tchx84.Flatseal";
      	    origin = "flathub";
      	  }
      	];
      };
    };

    environment.persistence."/persist" = {
      users.${isUser} = {
        directories = [
          ".var/app/com.github.tchx84.Flatseal"
	      ];
      };
    };
  };
}
