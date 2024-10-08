{ pkgs
, config
, lib
, ...
}:{
  options = {
    custom.neovim = {
      enable = lib.mkEnableOption "Neovim config";
    };
  };

  config = lib.mkIf config.custom.neovim.enable {
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
  };
}
