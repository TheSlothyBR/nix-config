{ inputs
, config
, lib
, pkgs
, ...
}:{
  options = {
    custom.fonts = {
      enable = lib.mkEnableOption "Fonts config";
    };
  };

  config = lib.mkIf config.custom.fonts.enable {
    fonts = {
      packages = with pkgs; [
        cantarell-fonts
        (nerdfonts.override { fonts = [ "FiraCode" ]; })
      ];
      fontconfig = {
        defaultFonts = {
          sansSerif = [ "Cantarell" ];
          monospace = [ "FiraCode Nerd Font Mono" ];
        };
      };
    };
  };
}

