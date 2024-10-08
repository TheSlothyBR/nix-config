{ config
, pkgs
, lib
, ...
}:{
  options = {
    custom.kate = {
      enable = lib.mkEnableOption "Kate config";
    };
  };

  config = lib.mkIf config.custom.kate.enable {
    environment.systemPackages = with pkgs.kdePackages; [
      kate
    ];
  };
}
