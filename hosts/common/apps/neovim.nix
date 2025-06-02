{
  inputs,
  pkgs,
  config,
  lib,
  ...
}:
{
  imports = [
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

          clipboard.registers = "unnamedplus";
          lineNumberMode = "relative";
          searchCase = "smart";
          preventJunkFiles = true;
          undoFile = {
            enable = true;
          };

          globals = {
            options = {
              mapleader = " ";
            };
          };

          options = {
            backspace = "indent,eol,start";
            cursorline = true;
            #completeopt = "menuone,noselect";
            expandtab = true;
            jumpoptions = "view";
            #keymodel = "startsel";
            list = true;
            #listchars = "trail:·,nbsp:¿,tab:¿ ,extends:¿,precedes:¿";
            mouse = "nicr";
            #mousemodel = "extend";
            number = true;
            numberwidth = 3;
            pumheight = 10;
            relativenumber = true;
            scrolloff = 8;
            #selection = "inclusive";
            #selectmode = "key,mouse,cmd";
            shiftwidth = 2;
            signcolumn = "no";
            smarttab = true;
            smartindent = true;
            softtabstop = -1;
            spell = true;
            splitright = true;
            splitbelow = true;
            tabstop = 2;
            undolevels = 10000;
            wrap = true;
            wildmenu = true;
          };
          luaConfigRC.basic = ''
            vim.opt.path:append({ "**" })
            vim.opt.iskeyword:append("-")
            -- vim.opt.whichwrap:append( '<,>,h,l,[,]' )
          '';

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

    programs.nano.enable = false;

    environment = {
      sessionVariables = {
        VISUAL = "nvim";
        SUDO_EDITOR = "nvim";
        MANPAGER = "nvim +Man!";
      };
      systemPackages = with pkgs; [
        nixfmt-rfc-style
        nil
      ];
    };
  };
}
