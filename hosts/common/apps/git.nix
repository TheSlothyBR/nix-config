{ pkgs
, isUser
, config
, lib
, ...
}:{
  options = {
    custom.git = {
      enable = lib.mkEnableOption "Git config";
    };
  };

  config = lib.mkIf config.custom.git.enable {
    sops.secrets."git/name" = {};
    sops.secrets."git/email" = {};
    home-manager.users.${isUser} = {
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
        ln -sf /home/${isUser}/.config/git/config /etc/gitconfig
      ''; 
    };
  };
}
