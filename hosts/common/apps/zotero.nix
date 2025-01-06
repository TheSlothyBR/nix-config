{ config
, isUser
, lib
, ...
}:{
  options = {
    custom.zotero = {
      enable = lib.mkEnableOption "Zotero config";
	  autostart = lib.mkEnableOption "Autostart Zotero";
    };
  };

  config = lib.mkIf config.custom.zotero.enable {
    home-manager.users.${isUser} = {
      services.flatpak = {
        packages = [
          {
            appId = ".var/app/org.zotero.Zotero";
            origin = "flathub";
          }
        ];
        #overrides = {
        #  "org.zotero.Zotero" = {
        #    Context = {
        #      sockets = [
        #        "wayland"
        #        "x11"
        #      ];
        #    };
        #  };
        #};
      };
    };

    environment.persistence."/persist" = {
      users.${isUser} = {
        directories = [
          ".var/app/org.zotero.Zotero"
        ];
      };
    };

    systemd.services."generate-zotero-autostart" = lib.mkIf config.custom.zotero.autostart {
      description = "Generate Zotero Autostart";
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        Type = "oneshot";
        User = "${isUser}";
        Group = "users";
      };
      script = ''
#        mkdir -p ~/.config/autostart
#        cat << 'EOF' > ~/.config/autostart/org.zotero.Zotero.desktop
#EOF
      '';
    };

    systemd.services."generate-zotero-config" = {
      description = "Generate Zotero Config";
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        Type = "oneshot";
        User = "${isUser}";
        Group = "users";
      };
      script = ''
#        mkdir -p ~/.var/app/org.zotero.Zotero/zotero/zotero
#        cat << 'EOF' > ~/.var/app/org.zotero.Zotero/zotero/zotero/prefs.js
#EOF
      '';
    };
  };
}
