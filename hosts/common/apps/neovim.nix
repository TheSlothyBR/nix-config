{ inputs
, pkgs
, config
, lib
, ...
}:{
  imports = [
    inputs.nixvim.nixosModules.nixvim
  ];

  options = {
    custom.neovim = {
      enable = lib.mkEnableOption "Neovim config";
    };
  };

  config = lib.mkIf config.custom.neovim.enable {
    programs.nixvim = {
      enable = true;
      enableMan = true;
      defaultEditor = true;
      vimAlias = true;
      viAlias = true;
      opts = {
      	number = true;
      	relativenumber = true;
        expandtab = true;
      	smarttab = true;
      	tabstop = 2;
      	softtabstop = 2;
      	shiftwidth = 2;
      	wrap = true;
      };
      colorschemes.nord.enable = true;
      globals = {
        mapleader = " ";
        clipboard = {
	        providers.wl-copy.enable = true;
          register = "unnamedplus";
        };
      };
      plugins = {
        lualine.enable = true;
      };
    };

    programs.nano.enable = false;

    environment.sessionVariables = {
      VISUAL = "nvim";
      SUDO_EDITOR = "nvim";
    };
  };
}
