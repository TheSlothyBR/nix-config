{ config
, lib
, ...
}:{
  options = {
    custom.bootloader = {
      enable = lib.mkEnableOption "Bootloader config";
      systemd-boot.enable = lib.mkEnableOption "Bootloader config";
    };
  };

  config = lib.mkIf config.custom.bootloader.enable {
    boot.loader = {
      efi = {
        canTouchEfiVariables = true;
      };
      systemd-boot = {
	    enable = config.custom.bootloader.systemd-boot.enable;
	    editor = false;
	  };
    };
  };
}
