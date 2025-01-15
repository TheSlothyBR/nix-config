{ config
, lib
, ...
}:{
  imports = [
   ../common
   ./system
  ];

  custom = {
    ark.enable = false;
    battery-optimisation.enable = false;
    bluetooth.enable = false;
    bootloader = {
      enable = true;
      systemd-boot.enable = true;
    };
    bottles.enable = false;
    brave.enable = false;
    calculator.enable = false;
    calibre.enable = false;
    flatpak.enable = false;
    flatseal.enable = false;
    font-viewer.enable = false;
    fonts.enable = false;
    gestures.enable = false;
    git.enable = true;
    inputs.enable = true;
    jamovi.enable = false;
    kando.enable = false;
    kate.enable = false;
    keepassxc = {
      enable = false;
      autostart = true;
    };
    kernel.enable = true;
    ksnip.enable = false;
    loupe.enable = false;
    lutris.enable = false;
    mimeapps.enable = false;
    neovim.enable = true;
    nix-config = {
      enable = true;
      allowUnfree = true;
    };
    nur.enable = false;
    nyxt.enable = false;
    obsidian.enable = false;
    okular.enable = false;
    onlyoffice.enable = false;
    plasma.enable = false;
    plymouth.enable = false;
    protonplus.enable = false;
    rclone.enable = false;
	retrodeck.enable = false;
    scribus.enable = false;
    sddm.enable = false;
    shell.enable = false;
    sops.enable = true;
    sound = {
      enable = true;
      jack.enable = false;
    };
    ssh.enable = true;
    standardnotes.enable = false;
    steam.enable = false;
    stremio.enable = false;
    thunderbird.enable = false;
    utils.enable = true;
    vlc.enable = false;
    warehouse.enable = false;
    wezterm.enable = false;
    wifi-adapter.enable = true;
    zellij.enable = false;
	zotero = {
	  enable = false;
	  autostart = false;
	};
    zswap.enable = true;
  };
}
