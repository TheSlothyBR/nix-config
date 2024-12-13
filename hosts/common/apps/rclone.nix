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
          rclone rcd --rc-web-gui --rc-user=${isUser} --rc-pass="$(cat ${config.sops.secrets."drive/id".path})"
        '';
      })
      (pkgs.writeShellApplication {
        name = "bisync-rclone-test";
        runtimeInputs = [ pkgs.rclone ];
        text = ''
          rclone bisync "''${DRIVE}/Test" "OneDrive:Test" \
            --filter-from "''${DRIVE}/Meta/.filter" \
            --transfers=8 \
            --onedrive-chunk-size=128M \
            --onedrive-delta \
            --fast-list \
            --use-mmap \
            --progress \
            --compare modtime,checksum \
            --conflict-resolve newer \
            --conflict-loser num \
            --conflict-suffix "conflict-{DateOnly}" \
            --create-empty-src-dirs \
            --track-renames \
            --track-renames-strategy hash \
            --delete-after \
            --resilient \
            --recover \
            --no-update-modtime \
            --no-update-dir-modtime \
            --verbose \
            --log-file=.cache/rclone/logs.txt
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
