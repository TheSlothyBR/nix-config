{ config
, isUser
, lib
, ...
}:{
  options = {
    custom.stremio = {
      enable = lib.mkEnableOption "Stremio config";
	    autostart = lib.mkEnableOption "Autostart Stremio";
    };
  };

  config = lib.mkIf config.custom.stremio.enable {
    home-manager.users.${isUser} = {
      services.flatpak = {
        packages = [
          {
            appId = "com.stremio.Stremio";
            origin = "flathub";
          }
        ];
      };
    };

    systemd.services."generate-stremio-autostart" = lib.mkIf config.custom.stremio.autostart {
      description = "Generate Stremio Autostart";
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        Type = "oneshot";
        User = "${isUser}";
        Group = "users";
      };
      script = ''
        #mkdir -p ~/.config/autostart
        #cat << 'EOF' > ~/.config/autostart/.desktop
	    '';
    };

    environment.persistence."/persist" = {
      users.${isUser} = {
        directories = [
          ".var/app/com.stremio.Stremio"
        ];
      };
    };
  };
}
