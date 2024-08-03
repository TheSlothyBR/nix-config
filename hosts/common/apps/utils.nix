{ config
, pkgs
, ...
}:{
  config = {
    environment.systemPackages = with pkgs; [
      wget
      sbctl
    ]
  };
}
