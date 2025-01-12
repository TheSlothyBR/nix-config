{ pkgs
, config
, globals
, isCofig
, ...
}:{
  imports = [
    (nixpkgs.outPath + "/nixos/modules/profiles/perlless.nix")
    ./system
  ];
  
  fileSystems."/".device = "${builtins.elemAt globals.${isConfig}.drives 0}";

  nixpkgs.hostPlatform = builtins.elemAt globals.meta.architectures 0;

  nix.settings.experimental-features = [ 
    "nix-command"
    "flakes"
  ];

  boot = {
    kernelPackages = pkgs.linuxPackages_custom_tinyconfig_kernel;
    loader.systemd-boot.enable = true;
  };

  environment.systemPackages = with pkgs; [
    
  ];
}
