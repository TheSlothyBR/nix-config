{ inputs
, config
, lib
, pkgs
, ...
}:{
 # imports = [
 #   inputs.stylix.nixosModules.stylix
 # ];

  options = {
    custom.stylix = {
      enable = lib.mkEnableOption "Stylix config";
      #add wallpaper override option
    };
  };

 # config = lib.mkIf config.custom.stylix.enable {
 #   stylix = {
 #     enable = config.custom.stylix.enable;
 #     image = pkgs.fetchurl {
 #       url = "https://raw.githubusercontent.com/D3Ext/aesthetic-wallpapers/main/images/horror_cult.jpg";
 #       sha256 = "sha256-y1QVsm9sUJtNDYqu28HU43469rLn6uWxbIRZlnPS/qs=";
 #     };
 #   };
 # };
}
