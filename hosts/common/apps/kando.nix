{ config
, isUser
, lib
, ...
}:{
  options = {
    custom.kando = {
      enable = lib.mkEnableOption "Kando config";
    };
  };

  config = lib.mkIf config.custom.kando.enable {
    home-manager.users.${isUser} = {
      services.flatpak = {
        packages = [
          {
            appId = "menu.kando.Kando";
            origin = "flathub";
          }
        ];
      };
    };

    environment.persistence."/persist" = {
      users.${isUser} = {
        directories = [
          ".var/app/menu.kando.Kando"
        ];
      };
    };

    systemd.services."generate-kando-autostart" = {
      description = "Generate Kando Autostart";
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        Type = "oneshot";
        User = "${isUser}";
        Group = "users";
      };
      script = ''
        mkdir -p ~/.config/autostart
        cat << 'EOF' > ~/.config/autostart/menu.kando.Kando.desktop
[Desktop Entry]
Categories=Utility;
Comment=The Cross-Platform Pie Menu.
Exec=flatpak run --branch=stable --arch=x86_64 --command=AppRun --file-forwarding menu.kando.Kando @@u %U @@
Icon=menu.kando.Kando
Name=Kando
Terminal=false
Type=Application
Version=1.0
X-Flatpak=menu.kando.Kando
EOF
      '';
    };
  };
}
