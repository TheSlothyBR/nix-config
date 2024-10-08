{ config
, lib
, ...
}:{
  options = {
    custom.wifi-adapter = {
      enable = lib.mkEnableOption "Wi-Fi adapter drive";
    };
  };

  config = lib.mkIf config.custom.wifi-adapter.enable {
    boot.extraModulePackages = [ config.boot.kernelPackages.rtl8812au ];
  };
}
