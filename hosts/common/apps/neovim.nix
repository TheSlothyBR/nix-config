{ inputs
, globals
, isConfig
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
      diagnostics.virtual_lines.only_current_line = true;
      #extraPlugins = '''';
      plugins = {
        lualine.enable = true;
        mini = {
          enable = true;
          modules = {
            files = { };
          };
        };
        treesitter = {
          enable = true;
          #autoLoad = true;
          settings = {
            indent.enable = true;
            highlight.enable = true;
          };
          #folding = true;
          nixvimInjections = true;
        };
        lsp-lines.enable = true;
        lsp = {
          servers = {
            bashls.enable = true;
            nixd = {
              enable = true;
              autostart = true;
              #cmd = [ "nixd" ];
              #filetypes = [ "nix" ];
              #rootDir = [ "flake.nix" ".git" ];
              settings = 
              let
                flake = ''(builtins.getFlake "${globals.${isConfig}.persistFlakePath}")'';
              in {
                nixpkgs.expr = ''import ${flake}.inputs.nixpkgs {}'';
                formatting.command = [ "${lib.getExe pkgs.nixfmt-rfc-style}" ];
                options = rec {
                  nixos.expr = "${flake}.nixosConfigurations.${isConfig}.options";
                  home-manager.expr = "${flake}.homeConfigurations.${isConfig}.options";
                  nixvim.expr = "${flake}.packages.${builtins.currentSystem}.nvim.options";
                };
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
        nixd
      ];
    };
  };
}
