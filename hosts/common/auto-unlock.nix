{ inputs
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
  security.pam.services.keepassxc.text = ''
    session optional pam_exec.so expose_authtok  ${script}
  ''
}
