{ globals
, ...
}:{
  networking = {
    hostName = "${globals.ultra.hostName}";
    wireless.iwd.enable = true;
    networkmanager = {
      enable = true;
      wifi.backend = "iwd";
    };
  };
}
