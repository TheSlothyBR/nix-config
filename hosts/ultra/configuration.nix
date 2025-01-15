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
    bottles.enable = true;
    brave.enable = true;
    calculator.enable = true;
    calibre.enable = true;
    flatpak.enable = true;
    flatseal.enable = true;
    font-viewer.enable = true;
    fonts.enable = true;
    gestures.enable = true;
    git.enable = true;
    inputs.enable = true;
    jamovi.enable = true;
    kando.enable = true;
    kate.enable = true;
    keepassxc = {
      enable = true;
      autostart = true;
    };
    kernel.enable = true;
    ksnip.enable = true;
    loupe.enable = true;
    lutris.enable = true;
    mimeapps.enable = true;
    neovim.enable = true;
    nix-config = {
      enable = true;
      allowUnfree = true;
    };
    nur.enable = true;
    nyxt.enable = true;
    obsidian.enable = true;
    okular.enable = true;
    onlyoffice.enable = true;
    plasma.enable = true;
    plymouth.enable = true;
    protonplus.enable = true;
    rclone.enable = true;
	retrodeck.enable = true;
    scribus.enable = true;
    sddm.enable = true;
    shell.enable = true;
    sops.enable = true;
    sound = {
      enable = true;
      jack.enable = false;
    };
    ssh.enable = true;
    standardnotes.enable = true;
    steam.enable = true;
    stremio.enable = true;
    thunderbird.enable = true;
    utils.enable = true;
    vlc.enable = true;
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
