{ config
, lib
, ...
}:{
  options = {
    custom.gestures = {
      enable = lib.mkEnableOption "Gestures config";
    };
  };

  config = lib.mkIf config.custom.gestures.enable {
    services.libinput.enable = true;
  };
}
