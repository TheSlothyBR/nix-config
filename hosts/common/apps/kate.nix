{ config
, pkgs
, ...
}:{
  config = {
    environment.systemPackages = with pkgs.kdePackages; [
      kate
    ];
  };
}
