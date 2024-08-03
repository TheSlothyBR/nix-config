{ nixpkgs
, globals
, ...
}:{
  home-manager.users.${globals.ultra.userName} = {
    programs = {
      wezterm = {
        enable = true;
        enableBashIntegration = true;
      };
    };
  };
}
