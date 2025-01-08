{ config
, isUser
, lib
, ...
}:{
  options = {
    custom.lutris = {
      enable = lib.mkEnableOption "Lutris config";
      autostart = lib.mkEnableOption "Autostart Lutris";
    };
  };

  config = lib.mkIf config.custom.lutris.enable {
    home-manager.users.${isUser} = {
      services.flatpak = {
        packages = [
          {
            appId = "net.lutris.Lutris";
            origin = "flathub";
          }
        ];
        overrides = {
          "net.lutris.Lutris" = {
            Context = {
              sockets = [
                "wayland"
              ];
              filesystems = [
                "!home"
                "~/Games"
                "~/.steam"
				".var/app/org.libretro.RetroArch:ro"
              ];
            };
          };
        };
      };
    };

    systemd.services."lutris-steam-link" = {
      description = "Creates symlink for Lutris to use Steam flatpak";
      wantedBy = [ "multi-user.target" ];
      after = [ "sops-nix.service" ];
      serviceConfig.Type = "oneshot";
      script = ''
        ln -sf /home/${isUser}/.var/apps/com.valvesoftware.Steam/.steam /home/${isUser}/.steam
      '';
    };

    systemd.services."generate-lutris-autostart" = lib.mkIf config.custom.lutris.autostart {
      description = "Generate Lutris Autostart";
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
          ".var/app/net.lutris.Lutris"
        ];
      };
    };
  };
}
