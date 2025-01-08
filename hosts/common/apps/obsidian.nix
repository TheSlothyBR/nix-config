{ config
, isUser
, lib
, ...
}:{
  options = {
    custom.obsidian = {
      enable = lib.mkEnableOption "Obsidian.md config";
      autostart = lib.mkEnableOption "Autostart Obsidian";
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

    systemd.services."generate-obsidian-autostart" = lib.mkIf config.custom.obsidian.autostart {
      description = "Generate Obsidian Autostart";
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
          ".var/app/md.obsidian.Obsidian"
        ];
      };
    };
  };
}
