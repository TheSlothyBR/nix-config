{ pkgs
, ...
}:{
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    vimAlias = true;
    viAlias = true;
    #configure = { customRC = ''text''; };
    #runtime;
  };

  programs.nano.enable = false;

  environment.sessionVariables = {
    VISUAL = "nvim";
    SUDO_EDITOR = "nvim";
  };
}
