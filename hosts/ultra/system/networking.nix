{ globals
, ...
}:{
  services.resolved.enable = true;

  networking = {
    hostName = "${globals.ultra.hostName}";
    wireless.iwd.enable = true;
    networkmanager = {
      enable = true;
      dns = "systemd-resolved";
      wifi.backend = "iwd";
    };
  };
}
