{
  inputs,
  isUser,
  config,
  ...
}:
{
  imports = [
    inputs.home-manager.nixosModules.home-manager
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

  sops.secrets."${isUser}/password" = {
    sopsFile = ./secrets/secrets.yaml;
    neededForUsers = true;
  };
  users.mutableUsers = true;
  users.users."${isUser}" = {
    isNormalUser = true;
    extraGroups = builtins.filter (group: builtins.hasAttr group config.users.groups) [
      "wheel"
      "audio"
      "video"
      "networkmanager"
      "libvirtd"
      "wireshark"
    ];
    hashedPasswordFile = config.sops.secrets."${isUser}/password".path;
  };

  home-manager = {
    extraSpecialArgs = { inherit inputs; };
    useUserPackages = true;
    useGlobalPkgs = true;
    users.${isUser} = {
      programs.home-manager.enable = true;
      home = {
        stateVersion = "24.05";
        username = "${isUser}";
        homeDirectory = "/home/${isUser}";
        packages = [

        ];
      };
    };
  };

  system.stateVersion = "24.05";
}
