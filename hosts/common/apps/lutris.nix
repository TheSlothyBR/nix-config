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
                ".var/app/org.libretro.RetroDeck:ro"
              ];
            };
          };
        };
      };
    };

    systemd.services."lutris-steam-link" = {
      description = "Creates symlink for Lutris to use Steam flatpak";
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        Type = "oneshot";
        User = "${isUser}";
        Group = "users";
      };
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
        mkdir -p ~/.config/autostart
        cat << 'EOF' > ~/.config/autostart/net.lutris.Lutris.desktop
[Desktop Entry]
Categories=Game;
Comment=Video Game Preservation Platform
Exec=flatpak run --branch=stable --arch=x86_64 --command=lutris --file-forwarding net.lutris.Lutris @@u %U @@
Icon=net.lutris.Lutris
Keywords=gaming;wine;emulator;
MimeType=x-scheme-handler/lutris;
Name=Lutris
StartupNotify=true
StartupWMClass=Lutris
Terminal=false
Type=Application
X-Desktop-File-Install-Version=0.28
X-Flatpak=net.lutris.Lutris
X-Flatpak-RenamedFrom=lutris.desktop;
X-GNOME-UsesNotifications=true
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
