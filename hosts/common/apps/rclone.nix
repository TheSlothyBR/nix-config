{ globals
, config
, pkgs
, ...
}:{
  config = {
    environment.systemPackages = with pkgs; [
      rclone
      rclone-browser
    ];
  };

  sops = {
    secrets = {
      drive = {
        token = {};
        id = {};
      };
    };
    templates."rclone.conf" = {
      content = ''
[OneDrive]
type = onedrive
token = ${config.sops.placeholder.drive.token}
drive_id = ${config.sops.placeholder.drive.id}
drive_type = personal
      '';
      path = "/persist/home/.config/rclone/rclone.conf";
      owner = "${globals.ultra.userName}";
      mode = "0660";
    };
  };
}
