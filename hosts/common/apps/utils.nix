{ config
, pkgs
, lib
, ...
}:{
  options = {
    custom.utils = {
      enable = lib.mkEnableOption "Utils config";
    };
  };

  config = lib.mkIf config.custom.utils.enable {
    environment = {
      systemPackages = with pkgs; [
        wget
        wl-clipboard
      ] ++ [
        nh
        nix-output-monitor
        nvd
      ];
      sessionVariables = {
        FLAKE = "/etc/nixos/dotfiles";
      };
    };
  };
}
