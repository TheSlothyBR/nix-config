{ config
, lib
, pkgs
, ...
}:{
  options = {
    custom.kernel = {
      enable = lib.mkEnableOption "Kernel config";
    };
  };

  config = lib.mkIf config.custom.kernel.enable {
    boot.kernelPackages = pkgs.linuxKernel.packages.linux_6_6;
  };
}
