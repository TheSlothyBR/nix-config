{ inputs
, config
, lib
, ...
}:{
  #imports = [
  #  inputs.stylix.nixosModules.stylix
  #];

  options = {
    custom.stylix = {
      enable = lib.mkEnableOption "Stylix config";
    };
  };

  config = lib.mkIf config.custom.stylix.enable {
    #stylix.enable = true;
  };
}

