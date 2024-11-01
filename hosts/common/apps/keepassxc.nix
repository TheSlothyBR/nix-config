{ pkgs
, config
, isUser
, lib
, ...
}:{
  options = {
    custom.keepassxc = {
      enable = lib.mkEnableOption "KeePassXC config";
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
  };
}
