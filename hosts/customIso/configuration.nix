{ pkgs
, modulesPath
, config
, ...
}:{
  imports = [
    "${modulesPath}/installer/cd-dvd/installation-cd-minimal.nix"
  ];

  nixpkgs.hostPlatform = "x86_64-linux";

  nix.settings.experimental-features = [ 
    "nix-command"
    "flakes"
  ];

  isoImage.squashfsCompression = "gzip -Xcompression-level 1";

  boot = {
    kernelPackages = pkgs.linuxKernel.packages.linux_6_6;
    extraModulePackages = [ config.boot.kernelPackages.rtl8812au ];
  };

  environment.systemPackages = with pkgs; [
    neovim
    git
    curl
    fsarchiver
  ];
}
