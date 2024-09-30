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

[SSHAgent]
Enabled=true
EOF
    '';
  };
}
