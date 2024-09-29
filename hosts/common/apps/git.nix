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
    wantedBy = [ "default.target" ];
    after = [ "sops-nix.service" ];
    serviceConfig = {
      Type = "oneshot";
      User = "root";
      Group = "root";
      PermissionsStartOnly = true;
      ExecStart = ''
        ln -s $HOME/.config/git/config /etc/gitconfig
      '';
    };
  };
}
