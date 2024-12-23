{ globals
, pkgs
, config
, ...
}:{
  security.pam.services = {
    sddm-autologin.text = ''
          auth     requisite pam_nologin.so
	  auth     required  pam_succeed_if.so uid >= ${toString config.services.displayManager.sddm.autoLogin.minimumUid} quiet
	  auth     required  pam_permit.so
	  auth     optional  pam_systemd_loadkey.so
				
	  account  include   sddm
			
	  password include   sddm
				
	  session  include   sddm
    '';
  };

  systemd.services.display-manager = {
    after = [
      "systemd-user-sessions.service"
      "getty@tty7.service"
      "plymouth-quit.service"
      "systemd-logind.service"
    ];
    conflicts = [
      "getty@tty7.service"
    ];
    serviceConfig = { KeyringMode = "inherit"; };
  };

  services.displayManager.sddm.settings = {
    Autologin = {
      Session = "plasma";
      User = "${globals.ultra.userName}";
    };
  };
}
