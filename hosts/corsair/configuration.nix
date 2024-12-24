{ config
, lib
, ...
}:{
  imports = [
   ../common
   ./system
  ];

  custom = {
    bluetooth.enable = true;
    bootloader = {
      enable = true;
      systemd-boot.enable = true;
    };
    brave.enable = false;
    calculator.enable = false;
    flatpak.enable = false;
    flatseal.enable = false;
    git.enable = true;
    inputs.enable = true;
    kando.enable = false;
    kate.enable = false;
    keepassxc = {
      enable = false;
      autostart = true;
    };
    kernel.enable = true;
    neovim.enable = true;
    nix-config = {
      enable = true;
      allowUnfree = true;
    };
    nur.enable = false;
    obsidian.enable = false;
    plasma.enable = false;
    plymouth.enable = false;
    rclone.enable = true;
    sddm.enable = false;
    sops.enable = true;
    sound = {
      enable = true;
      jack.enable = false;
    };
    ssh.enable = true;
    steam.enable = false;
    stremio.enable = false;
    stylix.enable = true;
    umu.enable = false;
    utils.enable = true;
    wezterm.enable = false;
    wifi-adapter.enable = true;
    zellij.enable = false;
    zswap.enable = true;
  };
}
