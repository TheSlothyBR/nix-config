{ inputs
, config
, lib
, pkgs
, ...
}:{
  imports = [
    inputs.nur.nixosModules.nur
  ];

  options = {
    custom.nur = {
      enable = lib.mkEnableOption "NUR config";
    };
  };

  config = lib.mkIf config.custom.nur.enable {
    nixpkgs.overlays = [
      (final: prev: {
        inputs.nur = import inputs.nur {
          nurpkgs = pkgs;
          inherit pkgs;
        };
      })
    ];

    environment.systemPackages = with config.nur.repos; [
      shadowrz.klassy-qt6
    ];
  };
}

