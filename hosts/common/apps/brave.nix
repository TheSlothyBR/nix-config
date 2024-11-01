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
                "{/var/lib,xdg-data}/flatpak/{app/org.keepassxc.KeePassXC,runtime/org.kde.Platform}:ro"
                "xdg-run/app/org.keepassxc.KeePassXC:create"
              ];
            };
            Environment = {
              GTK_THEME = "Adwaita:dark";
	          };
          };
        };
      };
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
#!${pkgs.runtimeShell}

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
