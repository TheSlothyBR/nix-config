{ inputs
, pkgs
, globals
, ...
}:{

  home-manager.users.${globals.ultra.userName} = {
    imports = [
      inputs.nix-flatpak.homeManagerModules.nix-flatpak
    ];
    services.flatpak = {
      enable = true;
      uninstallUnmanaged = true;
      overrides = {
        global = {
          Context.sockets = [
            "wayland"
            "!x11"
            "!fallback-x11"
          ];
        };
      };
    };
  };
}
