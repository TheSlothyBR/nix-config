{ globals
, inputs
, config
, lib
, ...
}:{
  imports = [
   ../common
   ./system
  ];

  custom = {
    brave.enable = true;
    keepassxc.enable = true;
    plasma.enable = true;
    rclone.enable = true;
    sops.enable = true;
    ssh.enable = true;
    wezterm.enable = true;
  };

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

  users.users.root.hashedPassword = "!";

  sops.secrets."${globals.ultra.hostName}/password".neededForUsers = true;
  users.mutableUsers = true;
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
