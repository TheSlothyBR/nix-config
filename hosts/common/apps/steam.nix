{ config
, isUser
, lib
, ...
}:{
  options = {
    custom.steam = {
      enable = lib.mkEnableOption "Steam config";
    };
  };

  config = lib.mkIf config.custom.steam.enable {
    home-manager.users.${isUser} = {
      services.flatpak = {
        packages = [
          {
            appId = "com.valvesoftware.Steam";
            origin = "flathub";
          }
        ];
        overrides = {
          "com.valvesoftware.Steam" = {
            Context = {
              sockets = [
                "wayland"
                "x11"
              ];
              filesystems = [
                "~/Games"
              ];
            };
          };
        };
      };
    };

    environment.persistence."/persist" = {
      users.${isUser} = {
        directories = [
          ".var/app/com.valvesoftware.Steam"
        ];
      };
    };

    systemd.services."generate-steam-autostart" = {
      description = "Generate Steam Autostart";
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        Type = "oneshot";
        User = "${isUser}";
        Group = "users";
      };
      script = ''
        mkdir -p ~/.config/autostart
        cat << 'EOF' > ~/.config/autostart/com.valvesoftware.Steam.desktop
[Desktop Action BigPicture]
Exec=flatpak run --branch=stable --arch=x86_64 --command=steam com.valvesoftware.Steam steam://open/bigpicture
Name=Big Picture

[Desktop Action Community]
Exec=flatpak run --branch=stable --arch=x86_64 --command=steam com.valvesoftware.Steam steam://url/SteamIDControlPage
Name=Community

[Desktop Action Friends]
Exec=flatpak run --branch=stable --arch=x86_64 --command=steam com.valvesoftware.Steam steam://open/friends
Name=Friends

[Desktop Action Library]
Exec=flatpak run --branch=stable --arch=x86_64 --command=steam com.valvesoftware.Steam steam://open/games
Name=Library

[Desktop Action News]
Exec=flatpak run --branch=stable --arch=x86_64 --command=steam com.valvesoftware.Steam steam://open/news
Name=News

[Desktop Action Screenshots]
Exec=flatpak run --branch=stable --arch=x86_64 --command=steam com.valvesoftware.Steam steam://open/screenshots
Name=Screenshots

[Desktop Action Servers]
Exec=flatpak run --branch=stable --arch=x86_64 --command=steam com.valvesoftware.Steam steam://open/servers
Name=Servers

[Desktop Action Settings]
Exec=flatpak run --branch=stable --arch=x86_64 --command=steam com.valvesoftware.Steam steam://open/settings
Name=Settings

[Desktop Action Store]
Exec=flatpak run --branch=stable --arch=x86_64 --command=steam com.valvesoftware.Steam steam://store
Name=Store

[Desktop Entry]
Actions=Store;Community;Library;Servers;Screenshots;News;Settings;BigPicture;Friends;
Categories=Network;FileTransfer;Game;
Comment=Application for managing and playing games on Steam
Exec=flatpak run --branch=stable --arch=x86_64 --command=/app/bin/steam --file-forwarding com.valvesoftware.Steam @@u %U @@
Icon=com.valvesoftware.Steam
MimeType=x-scheme-handler/steam;x-scheme-handler/steamlink;
Name=Steam
StartupWMClass=Steam
Terminal=false
Type=Application
X-Desktop-File-Install-Version=0.28
X-Flatpak=com.valvesoftware.Steam
X-Flatpak-RenamedFrom=steam.desktop;
X-Flatpak-Tags=proprietary;
EOF
      '';
    };
  };
}
