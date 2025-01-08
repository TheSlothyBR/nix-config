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
        mkdir -p ~/.config/autostart
        cat << 'EOF' > ~/.config/autostart/com.stremio.Stremio.desktop
[Desktop Entry]
Categories=AudioVideo;Video;Player;TV;
Comment=Video organizer for your Movies, TV Shows and TV Channels
Exec=flatpak run --branch=stable --arch=x86_64 --command=/app/opt/stremio/stremio --file-forwarding com.stremio.Stremio @@u %U @@
Icon=com.stremio.Stremio
MimeType=application/x-bittorrent;x-scheme-handler/magnet;x-scheme-handler/stremio;video/avi;video/msvideo;video/x-msvideo;video/mp4;video/x-matroska;
Name=Stremio
StartupWMClass=stremio
Terminal=false
Type=Application
Version=1.0
X-Desktop-File-Install-Version=0.27
X-Flatpak=com.stremio.Stremio
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
