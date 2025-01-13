{ inputs
, config
, lib
, ...
}:{
  options = {
    custom.mimeapps = {
      enable = lib.mkEnableOption "NUR config";
    };
  };

  config = lib.mkIf config.custom.mimeapps.enable {
    systemd.services."generate-mimeapps-file" = {
      description = "Generate mimeapps.list file";
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        Type = "oneshot";
        User = "${isUser}";
        Group = "users";
      };
      script = ''
        mkdir -p ~/.config
        cat << 'EOF' > ~/.config/mimeapps.list
[Default Applications]
${if config.custom.brave.enable then "x-scheme-handler/https=com.brave.Browser.desktop" else ""}
${if config.custom.brave.enable then "x-scheme-handler/http=com.brave.Browser.desktop" else ""}
image/*=org.gnome.Loupe.desktop
video/*=org.videolan.VLC.desktop
audio/*=org.videolan.VLC.desktop
application/pdf=org.kde.okular.desktop
text/*=org.kde.kate.desktop
application/x-torrent=org.kde.ktorrent.desktop
application/x-bittorrent=org.kde.ktorrent.desktop
x-scheme-handler/magnet=org.kde.ktorrent.desktop
[Added Associations]
x-scheme-handler/https=${if config.custom.brave.enable then "com.brave.Browser.desktop" else ""},${if config.custom.nyxt.enable then "engineer.atlas.Nyxt.desktop" else ""}
x-scheme-handler/http=${if config.custom.brave.enable then "com.brave.Browser.desktop" else ""},${if config.custom.nyxt.enable then "engineer.atlas.Nyxt.desktop" else ""}
[Removed Associations]
EOF
      '';
    };
  };
}

