{ pkgs
, ...
}:{
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    vimAlias = true;
    viAlias = true;
    configure = { customRC = ''
      set clipboard=unnamedplus
      set number relativenumber
    ''; };
    #runtime;
  };

  programs.nano.enable = false;

  environment.sessionVariables = {
    VISUAL = "nvim";
    SUDO_EDITOR = "nvim";
  };
}
