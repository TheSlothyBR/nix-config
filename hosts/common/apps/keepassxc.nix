{ pkgs
, globals
, ...
}:{
  environment.systemPackages = with pkgs; [
    keepassxc
  ];

  systemd.services."generate-keepassxc-config" = {
    description = "Generate KeePassXC config";
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type = "oneshot";
      User = "${globals.ultra.userName}";
      Group = "users";
    };
    script = ''
      mkdir -p ~/.config/keepassxc
      cat << 'EOF' > ~/.config/keepassxc/keepassxc.ini
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

      mkdir -p ~/.cache/keepassxc
      cat << 'EOF' > ~/.cache/keepassxc/keepassxc.ini
[General]
LastOpenedDatabases=/home/${globals.ultra.userName}/Drive/Apps/KeePassXC/s.kdbx
LastDatabases=/home/${globals.ultra.userName}/Drive/Apps/KeePassXC/s.kdbx
LastActiveDatabase=/home/${globals.ultra.userName}/Drive/Apps/KeePassXC/s.kdbx
EOF
    '';
  };
}
