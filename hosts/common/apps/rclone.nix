{ globals
, config
, pkgs
, ...
}:{
  environment.systemPackages = with pkgs; [
    rclone
    rclone-browser
  ];

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
