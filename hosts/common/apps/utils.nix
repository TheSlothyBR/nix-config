{ config
, pkgs
, ...
}:{
  config = {
    environment.systemPackages = with pkgs; [
      wget
      sbctl
    ] ++ [
      nh
      nix-output-monitor #required by nh
      nvd #required by nh
    ];
  };
}
