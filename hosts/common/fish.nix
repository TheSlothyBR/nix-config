{ config
, isUser
, globals
, pkgs
, lib
, ...
}:{
  options = {
    custom.fish = {
      enable = lib.mkEnableOption "Fish shell config";
    };
  };

  config = lib.mkIf config.custom.fish.enable {

    programs = {
      fish.enable = true;
      starship = {
        enable = true;
        settings = {
          format = ''
[真真真真真真真真真真>](bold green)$battery$direnv$directory
[真>](bold green)$git_branch'';
          directory = {
            truncation_length = 4;
          };
        };
      };
    };
    
    users.users."${isUser}" = {
      shell = pkgs.fish;
    };

    environment = {
      systemPackages = with pkgs; [
        bat
        erdtree
        eza
        fzf
        tealdeer
        zoxide
      ];
      shellAliases = {
        "cat" = "bat";
        "ls" = "eza --icons";
        "l" = "eza -a --icons";
        "ll" = "eza -a --icons --long --extended --git --header";
        "t" = "erd";
        "cd" = "z";
      };
    };
  };
}
