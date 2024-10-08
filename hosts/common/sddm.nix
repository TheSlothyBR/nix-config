{ config
, lib
, ...
}:{
  options = {
    custom.sddm ={
      enable = lib.mkEnableOption "SDDM config";
    };
  };

  config = lib.mkIf config.custom.sddm.enable {
    services.displayManager = {
      sddm = {
        enable = true;
        wayland = {
          enable = true;
          compositor = "kwin";
        };
        autoNumlock = true;
        theme = "breeze";
      };
      defaultSession = "plasma";
    };
  };
}
