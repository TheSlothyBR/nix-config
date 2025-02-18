{
  config,
  lib,
  pkgs,
  ...
}:
{
  options = {
    custom.workflow = {
      enable = lib.mkEnableOption "Tools used in productivity workflow";
    };
  };

  config = lib.mkIf config.custom.workflow.enable {
    environment.systemPackages = with pkgs; [
      pandoc
      tesseract
      texliveFull
      pdfannots2json
      imagemagick
      ffmpeg
    ];
  };
}
