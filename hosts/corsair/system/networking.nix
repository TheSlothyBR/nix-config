{ isConfig
, ...
}:{
  services.resolved.enable = true;

  networking = {
    hostName = "${isConfig}";
    wireless.iwd.enable = true;
    networkmanager = {
      enable = true;
      dns = "systemd-resolved";
      wifi.backend = "iwd";
    };
  };
}
