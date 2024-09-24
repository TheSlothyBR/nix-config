{ pkgs
, ...
}:{
  boot = {
    plymouth = {
      enable = true;
      theme = "Hud 3";
      themePackages = with pkgs; [
        (adi1090x-plymouth-themes.override {
          selected_themes = [ "Hud 3" ];
        })
      ];
    };
    
    #consoleLogLevel = 0;
    #initrd.verbose = false;
    #kernelParams = [
    #  "quiet"
    #  "splash"
    #  "boot.shell_on_fail"
    #  "loglevel=3"
    #  "rd.systemd.show_status=false"
    #  "rd.udev.log_level=3"
    #  "udev.log_priority=3"
    #];
    #loader.timeout = 0;
  };
}
