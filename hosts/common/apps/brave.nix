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
      autostart = lib.mkEnableOption "Autostart Brave";
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
              filesystems = [
                "/var/lib/flatpak/app/org.keepassxc.KeePassXC:ro"
                "/var/lib/flatpak/runtime/org.kde.Platform:ro"
                "xdg-data/flatpak/app/org.keepassxc.KeePassXC:ro"
                "xdg-data/flatpak/runtime/org.kde.Platform:ro"
                "xdg-run/app/org.keepassxc.KeePassXC:create"
              ];
            };
          };
        };
      };
    };

    systemd.services."generate-brave-autostart" = lib.mkIf config.custom.brave.autostart {
      description = "Generate Lutris Autostart";
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        Type = "oneshot";
        User = "${isUser}";
        Group = "users";
      };
      script = ''
        mkdir -p ~/.config/autostart
        cat << 'EOF' > ~/.config/autostart/com.brave.Browser.desktop
[Desktop Action new-private-window]
Exec=flatpak run --branch=stable --arch=x86_64 --command=brave com.brave.Browser --incognito
Name=New Private Window

[Desktop Action new-tor-window]
Exec=flatpak run --branch=stable --arch=x86_64 --command=brave com.brave.Browser --tor
Name=New Private Window with Tor

[Desktop Action new-window]
Exec=flatpak run --branch=stable --arch=x86_64 --command=brave com.brave.Browser
Name=New Window

[Desktop Entry]
Actions=new-window;new-private-window;new-tor-window;
Categories=Network;WebBrowser;
Comment=Access the Internet
Exec=flatpak run --branch=stable --arch=x86_64 --command=brave --file-forwarding com.brave.Browser @@u %U @@
GenericName=Web Browser
Icon=com.brave.Browser
MimeType=application/pdf;application/rdf+xml;application/rss+xml;application/xhtml+xml;application/xhtml_xml;application/xml;image/gif;image/jpeg;image/png;image/webp;text/html;text/xml;x-scheme-handler/http;x-scheme-handler/https;x-scheme-handler/ipfs;x-scheme-handler/ipns;
Name=Brave
StartupNotify=true
StartupWMClass=brave-browser
Terminal=false
Type=Application
Version=1.0
X-Flatpak=com.brave.Browser
       '';
    };

    systemd.services."brave-chromium-cli-arguments" = {
      description = "Brave Chromium CLI Arguments";
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        Type = "oneshot";
        User = "${isUser}";
        Group = "users";
      };
      script = ''
#        cat << 'EOF' > ~/.var/app/com.brave.Browser/config/chromium-flags.conf
#--password-store=basic
#EOF
      '';
    };

    systemd.services."brave-keepassxc-integration" = {
      description = "Generate files for KeePassXC flatpak browser integration";
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        Type = "oneshot";
        User = "${isUser}";
        Group = "users";
      };
      script = ''
        cat << 'EOF' > ~/.var/app/com.brave.Browser/config/BraveSoftware/Brave-Browser/keepassxc-proxy-wrapper.sh
#!/bin/bash

APP_REF="org.keepassxc.KeePassXC/x86_64/stable"
for inst in "$HOME/.local/share/flatpak" "/var/lib/flatpak"; do
    if [ -d "$inst/app/$APP_REF" ]; then
        FLATPAK_INST="$inst"
        break
    fi
done
[ -z "$FLATPAK_INST" ] && exit 1

APP_PATH="$FLATPAK_INST/app/$APP_REF/active"

RUNTIME_REF=$(awk -F'=' '$1=="runtime" { print $2 }' < "$APP_PATH/metadata")
for inst in "$HOME/.local/share/flatpak" "/var/lib/flatpak"; do
    if [ -d "$inst/runtime/$RUNTIME_REF" ]; then
        FLATPAK_INST="$inst"
        break
    fi
done
[ -z "$FLATPAK_INST" ] && exit 1

RUNTIME_PATH="$FLATPAK_INST/runtime/$RUNTIME_REF/active"

exec flatpak-spawn \
    --env=LD_LIBRARY_PATH="/app/lib:/var/lib/flatpak/app/org.keepassxc.KeePassXC/x86_64/stable/active/" \
    --app-path="$APP_PATH/files" \
    --usr-path="$RUNTIME_PATH/files" \
    -- keepassxc-proxy "$@"
EOF
        chmod +x ~/.var/app/com.brave.Browser/config/BraveSoftware/Brave-Browser/keepassxc-proxy-wrapper.sh

        cat << 'EOF' > ~/.var/app/com.brave.Browser/config/BraveSoftware/Brave-Browser/NativeMessagingHosts/org.keepassxc.keepassxc_browser.json
{
    "allowed_origins": [
        "chrome-extension://pdffhmdngciaglkoonimfcmckehcpafo/",
        "chrome-extension://oboonakemofpalcgghocfoadofidjkkk/"
    ],
    "description": "KeePassXC integration with native messaging support",
    "name": "org.keepassxc.keepassxc_browser",
    "path": "/home/${isUser}/.var/app/com.brave.Browser/config/BraveSoftware/Brave-Browser/keepassxc-proxy-wrapper.sh",
    "type": "stdio"
}
EOF
      '';
    };

    environment.persistence."/persist" = {
      users.${isUser} = {
        directories = [
          ".var/app/com.brave.Browser"
        ];
      };
    };
  };
}
