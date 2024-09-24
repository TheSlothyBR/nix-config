{ globals
, config
, pkgs
, ...
}:{
  environment.systemPackages = with pkgs; [
    rclone
    rclone-browser
  ];

  systemd = {
    tmpfiles.settings = {
      "enforce-rclone-path-permission" = {
        "/persist/home/${globals.ultra.userName}/.config/rclone" = {
          d = {
            group = "users";
            user = "${globals.ultra.userName}";
            mode = "0740";
          };
        };
      };
    };
  };

  sops.secrets."drive/token" = {};
  sops.secrets."drive/id" = {};
  sops = {
    templates."rclone.conf" = {
      content = ''
[OneDrive]
type = onedrive
token = ${config.sops.placeholder."drive/token"}
drive_id = ${config.sops.placeholder."drive/id"}
drive_type = personal
      '';
      path = "/persist/home/.config/rclone/rclone.conf";
      owner = "${globals.ultra.userName}";
      mode = "0660";
    };
  };
}
