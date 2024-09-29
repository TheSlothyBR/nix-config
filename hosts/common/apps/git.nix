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

  systemd.services."link-gitconfig" = {
    description = "Sets credentials for root git";
    wantedBy = [ "multi-user.target" ];
    after = [ "sops-nix.service" ];
    serviceConfig.Type = "oneshot";
    script = ''
      ln -s /home/${globals.ultra.userName}/.config/git/config /etc/gitconfig
    ''; 
  };
}
