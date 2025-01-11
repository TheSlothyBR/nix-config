{ inputs
, config
, isUser
, lib
, ...
}:{
  options = {
    custom.warehouse = {
      enable = lib.mkEnableOption "Warehouse config";
    };
  };

  config = lib.mkIf config.custom.warehouse.enable {
    home-manager.users.${isUser} = {
      services.flatpak = {
        packages = [
          {
            appId = "io.github.flattool.Warehouse";
      	    origin = "flathub";
      	  }
      	];
      };
    };

    environment.persistence."/persist" = {
      users.${isUser} = {
        directories = [
          ".var/app/io.github.flattool.Warehouse"
	      ];
      };
    };
  };
}
