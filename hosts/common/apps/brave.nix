{ globals
, ...
}:{
  home-manager.users.${globals.ultra.userName} = {
    services.flatpak.packages = [
      {
        appId = "com.brave.Browser";
        origin = "flathub";
      }
    ];
  };
}
