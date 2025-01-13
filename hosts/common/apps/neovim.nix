{ inputs
, globals
, isConfig
, pkgs
, config
, lib
, ...
}:{
  imports = [
    #inputs.nixvim.nixosModules.nixvim
    inputs.nvf.nixosModules.default
  ];

  options = {
    custom.neovim = {
      enable = lib.mkEnableOption "Neovim config";
    };
  };

  config = lib.mkIf config.custom.neovim.enable {
    programs.nvf = {
      enable = true;
      enableManpages = true;
      settings = {
        vim = {
          theme = {
            enable = true;
            name = "dracula";
          };
          viAlias = true;
          vimAlias = true;
          enableLuaLoader = true;

          globals = {
            options = {
              mapleader = " ";
            };
          };

          options = {
            backspace = "indent,eol,start";
            expandtab = true;
            number = true;
            relativenumber = true;
            scrolloff = 8;
            shifttabstop = 2;
            shiftwidth = 2;
            signcolumn = "no";
            smarttab = true;
            smartindent = true;
            softtabstop = 2;
            spell = true;
            swapfile = false;
            tabstop = 2;
            undofile = true;
            undolevels = 10000;
            wrap = true;
          };

          statusline.lualine.enable = true;
          telescope.enable = true;
          autocomplete.nvim-cmp.enable = true;
          lsp = {
            formatOnSave = true;
          };
          
          languages = {
            bash = {
              enable = true;
              lsp = {
                enable = true;
              };
              format = {
                enable = true;
              };
              treesitter = {
                enable = true;
              };
              extraDiagnostics = {
                enable = true;
              };
            };
            nix = {
              enable = true;
              lsp = {
                enable = true;
              };
              format = {
                enable = true;
                type = "nixfmt";
              };
              treesitter = {
                enable = true;
              };
              extraDiagnostics = {
                enable = true;
              };
            };
          };
        };
      };
    };

    #programs.nixvim = {
    #  enable = true;
    #  enableMan = true;
    #  defaultEditor = true;
    #  editorconfig.enable = true;
    #  vimAlias = true;
    #  viAlias = true;
    #  luaLoader.enable = true;
    #  opts = {
    #    number = true;
    #    relativenumber = true;
    #    expandtab = true;
    #    smarttab = true;
    #    tabstop = 2;
    #    softtabstop = 2;
    #    shiftwidth = 2;
    #    scrolloff = 8;
    #    smartindent = true;
    #    spell = true;
    #    wrap = true;
    #    swapfile = false;
    #    undofile = true;
    #    undolevels = 10000;
    #  };
    #  clipboard = {
    #    providers.wl-copy = {
    #      enable = true;
    #      package = pkgs.wl-clipboard-rs;
    #    };
    #    register = "unnamedplus";
    #  };     
    #  #extraConfigLua = '''';
    #  colorschemes.nord = {
    #    enable = true;
    #    #lazyLoad.settings.colorscheme = "nord";
    #  };
    #  globals = {
    #    mapleader = " ";
    #    #maplocalleader = " ";
    #  };
    #  diagnostics.virtual_lines.only_current_line = true;
    #  #extraPlugins = '''';
    #  plugins = {
    #    lz-n.enable = true;
    #    lualine = {
    #      enable = true;
    #      #lazyLoad.settings.cmd = "lualine";
    #    };
    #    mini = {
    #      enable = true;
    #      lazyLoad.settings.cmd = "mini";
    #      modules = {
    #        files = { };
    #      };
    #    };
    #    telescope = {
    #      enable = true;
    #      lazyLoad.settings.cmd = "Telescope";
    #    };
    #    cmp = {
    #      enable = true;
    #      lazyLoad.settings.cmd = "cmp";
    #      autoEnableSources = true;
    #      settings = {
    #        sources = [
    #          { name = "nvim_lsp"; }
    #        ];
    #      };
    #    };
    #    treesitter = {
    #      enable = true;
    #      lazyLoad.settings.cmd = "Treesitter";
    #      settings = {
    #        indent.enable = true;
    #        highlight.enable = true;
    #      };
    #      nixGrammars = true;
    #      nixvimInjections = true;
    #    };
    #    lsp-lines = {
    #      enable = true;
    #      lazyLoad.settings.cmd = "lsp-lines";
    #    };
    #    lsp-format = {
    #      enable = true;
    #      lazyLoad.settings.cmd = "lsp-format";
    #      lspServersToEnable = "all";
    #      setup.eslint.sync = true;
    #    };
    #    lsp = {
    #      inlayHints = true;
    #      servers = {
    #        #bashls.enable = true;
    #        nixd = {
    #          enable = true;
    #          autostart = true;
    #          cmd = [ "nixd" ];
    #          settings = 
    #          let
    #            flake = ''(builtins.getFlake "${globals.${isConfig}.persistFlakePath}")'';
    #          in {
    #            nixpkgs.expr = ''import ${flake}.inputs.nixpkgs {}'';
    #            formatting.command = [ "${lib.getExe pkgs.nixfmt-rfc-style}" ];
    #            options = rec {
    #              nixos.expr = "${flake}.nixosConfigurations.${isConfig}.options";
    #              home-manager.expr = "${flake}.homeConfigurations.${isConfig}.options";
    #              nixvim.expr = "${flake}.packages.${builtins.currentSystem}.nvim.options";
    #            };
    #          };
    #        };
    #      };
    #    };
    #  };
    #};

    programs.nano.enable = false;
    
    environment = {
      sessionVariables = {
        VISUAL = "nvim";
        SUDO_EDITOR = "nvim";
        MANPAGER = "nvim +Man!";
      };
      systemPackages = with pkgs; [
        nixfmt-rfc-style
        #nixd
      ];
    };
  };
}
