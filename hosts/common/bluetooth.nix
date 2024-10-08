{ config
, lib
, ...
}:{
  options = {
    custom.bluetooth = {
      enable = lib.mkEnableOption "Bluetooth config";
    };
  };

  config = lib.mkIf config.custom.bluetooth.enable {
    hardware.bluetooth.enable = true;
  };
}
