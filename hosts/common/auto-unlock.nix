{ lib
, globals
, pkgs
}:let
    script = pkgs.writeShellScriptBin "unlocker" ''
    if ! pgrep keepassxc; then
      keepassxc && dbus-send --print-reply --dest=org.keepassxc.KeePassXC.MainWindow \
      /keepassxc org.keepassxc.KeePassXC.MainWindow.openDatabase \
      string:"s.kdbx" string:"$PAM_AUTH_TOK"
    fi
  ''
  in {
  security.pam.services = {
    keepassxc.text = ''
    session optional pam_exec.so expose_authtok  ${script}
  '';
    sddm-autologin.text = ''
      auth     requisite pam_nologin.so
	  auth     required  pam_succeed_if.so uid >= ${lib.toString config.services.displayManager.sddm.autoLogin.minimumUid} quiet
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