{ inputs
, config
, lib
, pkgs
, ...
}:{
  options = {
    custom.sddm ={
      enable = lib.mkEnableOption "SDDM config";
    };
  };

  config = lib.mkIf config.custom.sddm.enable {
    environment.systemPackages = [
      pkgs.sddm-astronaut #.override { themeConfig = ''text''; };
    ];

    services.displayManager = {
      defaultSession = "plasma";
      sddm = {
        enable = true;
        #package = lib.mkForce pkgs.kdePackages.sddm;
        extraPackages = [
          pkgs.sddm-astronaut
        ];
        wayland = {
          enable = true;
          compositor = "kwin";
        };
        autoNumlock = true;
        theme = "sddm-astronaut-theme";
      };
    };
  };
}
