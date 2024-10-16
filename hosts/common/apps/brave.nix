{ inputs
, config
, isUser
, pkgs
, lib
, ...
}:{
  options = {
    custom.brave = {
      enable = lib.mkEnableOption "Brave Browser config";
    };
  };

  config = lib.mkIf config.custom.brave.enable {
    home-manager.users.${isUser} = {
      services.flatpak = {
        packages = [
          {
            appId = "com.brave.Browser";
            origin = "flathub";
          }
        ];
        overrides = {
          "com.brave.Browser" = {
            Context = {
	      sockets = [
                "wayland"
		"x11"
	      ];
            };
            Environment = {
              GTK_THEME = "Adwaita:dark";
	    };
          };
        };
      };
    };

    environment.persistence."/persist" = {
      users.${isUser} = {
        directories = [
          ".var/app/com.brave.Browser/config/BraveSoftware/Brave-Browser/Default/Extensions"
          ".var/app/com.brave.Browser/.ld.so"
          ".var/app/com.brave.Browser/.local"
          ".var/app/com.brave.Browser/.pki"
          ".var/app/com.brave.Browser/data"
	];
        files = [
          ".var/app/com.brave.Browser/config/BraveSoftware/Brave-Browser/Default/Preferences"
          ".var/app/com.brave.Browser/config/BraveSoftware/Brave-Browser/Local State"
        ];
      };
    };
  };
}
