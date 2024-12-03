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
    programs = {
      nh = {
        enable = true;
        flake = "/etc/nixos/dotfiles";
        #clean.extraArgs = "--keep-since 2d";
      };
    };

    environment = {
      systemPackages = with pkgs; [
        wget
        wl-clipboard
        tealdeer
      #] ++ [
      #  nh
      #  nix-output-monitor
      #  nvd
      ];
      sessionVariables = {
      #  FLAKE = "/etc/nixos/dotfiles";
      };
    };
  };
}
