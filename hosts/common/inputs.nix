{ config
, lib
, ...
}:{
  options = {
    custom.inputs = {
      enable = lib.mkEnableOption "Inputs config";
    };
  };

  config = lib.mkIf config.custom.inputs.enable {
    console = {
      keyMap = "br-abnt2";
    };
    services = { 
      xserver.xkb = {
        layout = "br";
        variant = "nodeadkeys";
      };
    };
  };
}
