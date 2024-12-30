{ config
, pkgs
, lib
, ...
}:{
  options = {
    custom.plymouth = {
      enable = lib.mkEnableOption "Plymouth config";
    };
  };

  config = lib.mkIf config.custom.plymouth.enable {
    boot = {
      plymouth = {
        enable = true;
        extraConfig = "DeviceScale=1";
      };
      loader.systemd-boot.consoleMode = "max";

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
    };

    environment.systemPackages = with pkgs.kdePackages; [
      plymouth-kcm
    ];
  };
}
