{ pkgs
, config
, isUser
, lib
, ...
}:{
  options = {
    custom.keepassxc = {
      enable = lib.mkEnableOption "KeePassXC config";
      autostart = lib.mkEnableOption "Autostart KeePassXC";
    };
  };
  
  config = lib.mkIf config.custom.keepassxc.enable {
    home-manager.users.${isUser} = {
      services.flatpak = {
        packages = [
          {
            appId = "org.keepassxc.KeePassXC";
            origin = "flathub";
          }
        ];
        overrides = {
          "org.keepassxc.KeePassXC" = {
            Context = {
              filesystems = [
                "home/Drive/Apps/KeePassXC/s.kdbx:rw"
              ];
            };
          };
        };
      };
    };

    systemd.services."generate-keepassxc-config" = {
      description = "Generate KeePassXC config";
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        Type = "oneshot";
        User = "${isUser}";
        Group = "users";
      };
      script = ''
        mkdir -p ~/.var/app/org.keepassxc.KeePassXC/config/keepassxc
        cat << 'EOF' > ~/.var/app/org.keepassxc.KeePassXC/config/keepassxc/keepassxc.ini
[General]
ConfigVersion=2

[GUI]
TrayIconAppearance=monochrome-light
HideUsernames=true

[SSHAgent]
Enabled=true

[Browser]
Enabled=true
CustomProxyLocation=
EOF

        mkdir -p ~/.var/app/org.keepassxc.KeePassXC/cache/keepassxc
        cat << 'EOF' > ~/.var/app/org.keepassxc.KeePassXC/cache/keepassxc/keepassxc.ini
[General]
LastOpenedDatabases=/home/${isUser}/Drive/Apps/KeePassXC/s.kdbx
LastDatabases=/home/${isUser}/Drive/Apps/KeePassXC/s.kdbx
LastActiveDatabase=/home/${isUser}/Drive/Apps/KeePassXC/s.kdbx
EOF
      '';
    };

    systemd.services = lib.mkIf config.custom.keepassxc.autostart {
      "generate-keepassxc-autostart" = {
        description = "Generate KeePassXC Autostart";
        wantedBy = [ "multi-user.target" ];
        serviceConfig = {
          Type = "oneshot";
          User = "${isUser}";
          Group = "users";
        };
        script = ''
          mkdir -p ~/.config/autostart
          cat << 'EOF' > ~/.config/autostart/org.keepassxc.KeePassXC.desktop
[Desktop Entry]
Categories=Utility;Security;Qt;
Comment=Community-driven port of the Windows application “KeePass Password Safe”
Exec=flatpak run --branch=stable --arch=x86_64 --command=keepassxc --file-forwarding org.keepassxc.KeePassXC @@ %f @@
GenericName=Password Manager
Icon=org.keepassxc.KeePassXC
Keywords=security;privacy;password-manager;yubikey;password;keepass;
MimeType=application/x-keepass2;
Name=KeePassXC
SingleMainWindow=true
StartupNotify=true
StartupWMClass=keepassxc
Terminal=false
Type=Application
Version=1.5
X-Flatpak=org.keepassxc.KeePassXC
X-GNOME-SingleWindow=true
EOF
        '';
      };
    };
  };
}
