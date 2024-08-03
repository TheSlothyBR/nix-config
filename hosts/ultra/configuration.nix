{ globals
, lib
, pkgs
, inputs
, ...
}:{
  imports = with (../common/); [
    kernel.nix
    nix-config.nix
    unfree-pkgs.nix
    systemd-boot.nix
    sound.nix

    networking.nix
    bluetooth.nix
    wifi-adapter.nix

    inputs.nix
    gestures.nix

    sddm.nix
    plasma.nix

    apps/neovim.nix
    apps/git.nix
    apps/wezterm.nix
    apps/utils.nix
    apps/yazi.nix
  ] ++ [
    ./home/home.nix
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

  users.users."${globals.ultra.userName}" = {
    isNormalUser = true;
    extraGroups = [ 
      "audio"
      "networkmanager"
      "video"
      "wheel"
    ];
    initialPassword = " ";
  };

  system.stateVersion = "24.05";
}
