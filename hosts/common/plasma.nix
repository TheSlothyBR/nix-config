{
  pkgs
, lib
, ...
}:{
  services.desktopManager.plasma6.enable = true;

  environment.plasma6.excludePackages = with pkgs.kdePackages; [
    khelpcenter
    plasma-browser-integration
    print-manager
  ];
}
