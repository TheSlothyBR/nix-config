{ pkgs
, globals
, config
, ...
}:{

  sops.secrets."git/name" = {};
  sops.secrets."git/email" = {};
  home-manager.users.${globals.ultra.userName} = {
    programs.git = {
      enable = true;
      userName = config.sops.secrets."git/name".path;
      userEmail = config.sops.secrets."git/email".path;
    };
  };
}
