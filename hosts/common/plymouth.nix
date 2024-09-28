{ pkgs
, ...
}:{
  boot = {
    plymouth = {
      enable = true;
      theme = "hud_3";
      themePackages = with pkgs; [
        (adi1090x-plymouth-themes.override {
          selected_themes = [ "hud_3" ];
        })
      ];
    };

    consoleLogLevel = 0;
    initrd.verbose = false;
    kernelParams = [
      "quiet"
      "splash"
      "boot.shell_on_fail"
      "loglevel=3"
      "rd.systemd.show_status=false"
      "rd.udev.log_level=3"
      "udev.log_priority=3"
    ];
    #loader.timeout = 0;
  };

  environment.systemPackages = with pkgs.kdePackages; [
    plymouth-kcm
  ];
}
