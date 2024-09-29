{ pkgs
, globals
, ...
}:{
  environment.systemPackages = with pkgs; [
    keepassxc
  ];

  systemd.tmpfiles.settings = {
    "persist-keepassxc-local-settings" = {
      "/home/${globals.ultra.userName}/.config/keepassxc/keepassxc.ini" = {
        f = {
          group = "users";
	  user = "${globals.ultra.userName}";
	  mode = "0740";
	  argument = "[General]\nConfigVersion=2\n[GUI]TrayIconAppearance=monochrome-light\n[SSHAgent]\nEnabled=true";
	};
      };
    };
  };
}
