{ config
, lib
, ...
}:{
  options = {
    custom.yazi = {
      enable = lib.mkEnableOption "Yazi config";
    };
  };

  config = lib.mkIf config.custom.yazi.enable {
    programs.yazi.enable = true;
  };
}
