{ config
, globals
, ...
}:{
  home-manager.users.${globals.ultra.userName} = {
    services.flatpak.packages = [
      "com.brave.Browser"
    ];
  };
}
