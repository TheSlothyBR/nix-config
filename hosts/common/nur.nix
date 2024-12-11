{ inputs
, config
, lib
, pkgs
, ...
}:{
  imports = [
    inputs.nur.modules.nixos.default
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

    environment.systemPackages = with pkgs.nur.repos; [
      shadowrz.klassy-qt6
    ];
  };
}

