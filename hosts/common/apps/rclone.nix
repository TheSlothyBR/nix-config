{ config
, pkgs
, lib
, isUser
, ...
}:{
  options = {
    custom.rclone = {
      enable = lib.mkEnableOption "Rclone config";
    };
  };
  
  config = lib.mkIf config.custom.rclone.enable {
    environment.systemPackages = with pkgs; [
      rclone
      rclone-browser
      (pkgs.writeShellApplication {
        name = "drive-gui";
        runtimeInputs = [ pkgs.rclone ];
        text = ''
          rclone rcd --rc-web-gui --rc-user=${isUser} --rc-pass=$(cat ${config.sops.secrets."drive/id".path})
        '';
      })
    ];

    sops.secrets."drive/token" = {
      owner = "${isUser}";
    };
    sops.secrets."drive/id" = {
      owner = "${isUser}";
    };

    systemd.services."generate-rclone-config" = {
      description = "Generate Rclone Config";
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        Type = "oneshot";
        User = "${isUser}";
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
  };
}
