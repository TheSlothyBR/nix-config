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
        swapfile = false;
        undofile = true;
        undolevels = 10000;
      };
      clipboard = {
        providers.wl-copy = {
          enable = true;
          package = pkgs.wl-clipboard-rs;
        };
        register = "unnamedplus";
      };     
      #extraConfigLua = '''';
      colorschemes.nord.enable = true;
      globals = {
        mapleader = " ";
        maplocalleader = " ";
      };
      #extraPlugins = '''';
      plugins = {
        lualine.enable = true;
        mini = {
          enable = true;
          modules = {
            files = { };
          };
        };
        lsp = {
          servers = {
            nixd = {
              enable = true;
            };
          };
        };
      };
    };

    programs.nano.enable = false;

    environment = {
      sessionVariables = {
        VISUAL = "nvim";
        SUDO_EDITOR = "nvim";
        MANPAGER = "nvim +Man!";
      };
      systemPackages = with pkgs; [
        #nixfmt-rfc-style
        #nixd
      ];
    };
  };
}
