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
      pkgs.unstable.sddm-astronaut #.override { themeConfig = ''text''; };
    ];

    services.displayManager = {
      defaultSession = "plasma";
      sddm = {
        enable = true;
        package = pkgs.kdePackages.sddm;
        extraPackages = [
          pkgs.unstable.sddm-astronaut
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
