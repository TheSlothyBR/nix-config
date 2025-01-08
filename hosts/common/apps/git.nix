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
    environment.systemPackages = with pkgs; [
	  git
	];

	sops.secrets."git/name" = {
	  owner = "${isUser}";
	};
    sops.secrets."git/email" = {
	  owner = "${isUser}";
	};
    #home-manager.users.${isUser} = {
    #  programs.git = {
    #    enable = true;
    #    userName = config.sops.secrets."git/name".path;
    #    userEmail = config.sops.secrets."git/email".path;
    #  };
    #};

    systemd.services."generate-git-config" = {
      description = "Generate Git Config";
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        Type = "oneshot";
        User = "${isUser}";
        Group = "users";
      };
      script = ''
        mkdir -p ~/.config/git
        cat << 'EOF' > ~/.config/git/config
[user]
	name = name-placeholder
	email = email-placeholder
	username = name-placeholder
[init]
	defaultBranch = master
[core]
	editor = nvim
	whitespace = fix,-indent-with-non-tab,trailing-space,cr-at-eol
	pager = delta
EOF
        sed -i "s@name-placeholder@$(cat ${config.sops.secrets."git/name".path})@g" ~/.config/git/config
        sed -i "s@email-placeholder@$(cat ${config.sops.secrets."git/email".path})@g" ~/.config/git/config
      '';
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
