{ globals
, config
, pkgs
, ...
}:{
  environment.systemPackages = with pkgs; [
    rclone
    rclone-browser
  ];

  #systemd = {
  #  tmpfiles.settings = {
  #    "enforce-rclone-path-permission" = {
  #      "/home/${globals.ultra.userName}/.config/rclone" = {
  #        d = {
  #          group = "users";
  #          user = "${globals.ultra.userName}";
  #          mode = "0740";
  #        };
  #      };
  #    };
  #  };
  #};

  home-manager.users.${globals.ultra.userName} = {
    sops = {
      secrets = {
        drive-token = {
          path = "%r/drive/token";
          key = "drive/token";
	  mode = "0400";
	};
        drive-id = {
          path = "%r/drive/id";
          key = "drive/id";
	  mode = "0400";
        };
      };
      templates."rclone.conf" = {
        content = ''
[OneDrive]
type = onedrive
token = ${config.home-manager.users.${globals.ultra.userName}.sops.placeholder.drive-token}
drive_id = ${config.home-manager.users.${globals.ultra.userName}.sops.placeholder.drive-id}
drive_type = personal
        '';
        path = "/home/${globals.ultra.userName}/.config/rclone/rclone.conf";
        owner = "${globals.ultra.userName}";
        mode = "0600";
      };
    };
  };
}
