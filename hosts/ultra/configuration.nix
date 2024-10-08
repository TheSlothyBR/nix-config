{ config
, lib
, ...
}:{
  imports = [
   ../common
   ./system
  ];

  custom = {
    battery-optimisation.enable = true;
    bluetooth.enable = true;
    bootloader = {
      enable = true;
      systemd-boot.enable = true;
    };
    brave.enable = true;
    gestures.enable = true;
    git.enable = true;
    inputs.enable = true;
    kate.enable = true;
    keepassxc.enable = true;
    kernel.enable = true;
    nix-config = {
      enable = true;
      allowUnfree = true;
    };
    neovim.enable = true;
    obsidian.enable = true;
    plasma.enable = true;
    plymouth.enable = true;
    rclone.enable = true;
    sddm.enable = true;
    sops.enable = true;
    ssh.enable = true;
    sound = {
      enable = true;
      jack.enable = false;
    };
    utils.enable = true;
    wezterm.enable = true;
    wifi-adapter.enable = true;
    zswap.enable = true;
  };
}
