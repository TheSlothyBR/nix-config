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
    environment.systemPackages = with pkgs; [
      keepassxc
    ];

    systemd.services."generate-keepassxc-config" = {
      description = "Generate KeePassXC config";
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        Type = "oneshot";
        User = "${isUser}";
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
LastOpenedDatabases=/home/${isUser}/Drive/Apps/KeePassXC/s.kdbx
LastDatabases=/home/${isUser}/Drive/Apps/KeePassXC/s.kdbx
LastActiveDatabase=/home/${isUser}/Drive/Apps/KeePassXC/s.kdbx
EOF
      '';
    };
  };
}
