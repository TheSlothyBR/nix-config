{ inputs
, config
, lib
, pkgs
, ...
}:{
  options = {
    custom.umu = {
      enable = lib.mkEnableOption "umu config";
    };
  };

  config = lib.mkIf config.custom.umu.enable {
    environment.systemPackages = [
      (inputs.umu.packages.${pkgs.stdenv.hostPlatform.system}.umu.override {
        version = inputs.umu.shortRev;
        truststore = true;
      })
    ];
  };
}
