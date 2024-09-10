{ globals
, inputs
, config
, ...
}:{
  imports = [
    ../common/kernel.nix
    ../common/nix-config.nix
    ../common/unfree-pkgs.nix
    ../common/systemd-boot.nix
    ../common/sound.nix
    ../common/battery-optimisation.nix

    ../common/networking.nix
    ../common/bluetooth.nix
    ../common/wifi-adapter.nix

    ../common/ssh.nix
    ../common/sops.nix
    ../common/apps/keepassxc.nix
    ../common/auto-unlock.nix
    
    ../common/inputs.nix
    ../common/gestures.nix

    ../common/sddm.nix
    ../common/plasma.nix

    #systemd service fails as flatpak cant seem to access flathub repo uri through proxy, failing the system rebuild on vm
    #../common/flatpak.nix
    #../common/apps/brave.nix

    ../common/apps/neovim.nix
    ../common/apps/git.nix
    ../common/apps/wezterm.nix
    ../common/apps/utils.nix
    ../common/apps/yazi.nix
  ];
  
  time.timeZone = "America/Sao_Paulo";
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "pt_BR.UTF-8";
    LC_IDENTIFICATION = "pt_BR.UTF-8";
    LC_MEASUREMENT = "pt_BR.UTF-8";
    LC_MONETARY = "pt_BR.UTF-8";
    LC_NAME = "pt_BR.UTF-8";
    LC_NUMERIC = "pt_BR.UTF-8";
    LC_PAPER = "pt_BR.UTF-8";
    LC_TELEPHONE = "pt_BR.UTF-8";
    LC_TIME = "pt_BR.UTF-8";
  };

  #users.users.root.hashedPassword = "!";

  sops.secrets."${globals.ultra.hostName}/password".neededForUsers = true;
  #users.mutableUsers = true
  users.users."${globals.ultra.userName}" = {
    isNormalUser = true;
    extraGroups = [ 
      "audio"
      "networkmanager"
      "video"
      "wheel"
    ];
    hashedPasswordFile = config.sops.secrets."${globals.ultra.hostName}/password".path;
  };

  system.stateVersion = "24.05";
}
