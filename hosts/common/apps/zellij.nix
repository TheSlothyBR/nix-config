{ pkgs
, config
, isUser
, lib
, ...
}:{
  options = {
    custom.zellij = {
      enable = lib.mkEnableOption "Zellij config";
    };
  };

  config = lib.mkIf config.custom.zellij.enable {
    environment.systemPackages = with pkgs; [
      zellij
    ];
  };
}
