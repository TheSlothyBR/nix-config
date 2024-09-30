{ config
, pkgs
, globals
, ...
}:{
  environment.systemPackages = with pkgs; [
    rclone
    rclone-browser
  ];

  sops.secrets."drive/token" = {
    owner = "${globals.ultra.userName}";
  };
  sops.secrets."drive/id" = {
    owner = "${globals.ultra.userName}";
  };

  systemd.services."generate-rclone-config" = {
    description = "Generate Rclone Config";
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type = "oneshot";
      User = "${globals.ultra.userName}";
      Group = "users";
    };
    script = ''
      mkdir -p ~/.config/rclone
      cat << 'EOF' > ~/.config/rclone/rclone.conf
[OneDrive]
type = onedrive
token = token-placeholder
drive_id = id-placeholder
drive_type = personal
EOF
      sed -i "s@token-placeholder@$(cat ${config.sops.secrets."drive/token".path})@g" ~/.config/rclone/rclone.conf
      sed -i "s@id-placeholder@$(cat ${config.sops.secrets."drive/id".path})@g" ~/.config/rclone/rclone.conf
    '';
  };
}
