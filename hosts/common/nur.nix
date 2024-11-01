{ inputs
, config
, lib
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
    environment.systemPackages = with config.nur.repos; [
      shadowrz.klassy-qt6
    ];
  };
}

