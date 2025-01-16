{
  config,
  lib,
  pkgs,
  ...
}:
{
  options = {
    custom.fonts = {
      enable = lib.mkEnableOption "Fonts config";
    };
  };

  config = lib.mkIf config.custom.fonts.enable {
    fonts = {
      packages = with pkgs; [
        inter
        (nerdfonts.override { fonts = [ "FiraCode" ]; })
      ];
      fontconfig = {
        defaultFonts = {
          sansSerif = [ "Inter Variable 11" ];
          monospace = [ "FiraCode Nerd Font Mono" ];
        };
      };
    };
  };
}
