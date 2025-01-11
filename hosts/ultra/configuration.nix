{ config
, lib
, ...
}:{
  imports = [
   ../common
   ./system
  ];

  custom = {
    ark.enable = true;
    battery-optimisation.enable = true;
    bluetooth.enable = true;
    bootloader = {
      enable = true;
      systemd-boot.enable = true;
    };
    brave.enable = true;
    calculator.enable = true;
    calibre.enable = true;
    flatpak.enable = true;
    flatseal.enable = true;
    gestures.enable = true;
    git.enable = true;
    inputs.enable = true;
    kando.enable = true;
    kate.enable = true;
    keepassxc = {
      enable = true;
      autostart = true;
    };
    kernel.enable = true;
    lutris.enable = true;
    neovim.enable = true;
    nix-config = {
      enable = true;
      allowUnfree = true;
    };
    nur.enable = true;
    obsidian.enable = true;
    plasma.enable = true;
    plymouth.enable = true;
    protonplus.enable = true;
    rclone.enable = true;
	  retrodeck.enable = true;
    sddm.enable = true;
    sops.enable = true;
    sound = {
      enable = true;
      jack.enable = false;
    };
    ssh.enable = true;
    steam.enable = true;
    stremio.enable = true;
    stylix.enable = true;
    utils.enable = true;
    warehouse.enable = true;
    wezterm.enable = true;
    wifi-adapter.enable = true;
    zellij.enable = true;
	  zotero = {
	    enable = true;
	    autostart = false;
	  };
    zswap.enable = true;
  };
}
