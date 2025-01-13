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

          useSystemClipboard = true;
          #luaConfigRC.basic = '''';
          lineNumberMode = "relative";
          preventJunkFiles = true;
          searchCase = "smart";
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
            expandtab = true;
            number = true;
            relativenumber = true;
            scrolloff = 8;
            shiftwidth = 2;
            signcolumn = "no";
            smarttab = true;
            smartindent = true;
            softtabstop = -1;
            spell = true;
            tabstop = 2;
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
