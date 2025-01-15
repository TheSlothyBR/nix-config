{ config
, isUser
, globals
, pkgs
, lib
, ...
}:{
  options = {
    custom.shell = {
      enable = lib.mkEnableOption "Shell config";
    };
  };

  config = lib.mkIf config.custom.shell.enable {
    users.users."${isUser}" = {
      shell = pkgs.fish;
    };

    programs = {
      fish = {
        enable = true;
        interactiveShellInit = ''
          starship init fish | source
          zoxide init fish | source
        '';
      };
      starship = {
        enable = true;
        settings = {
          add_newline = false;
          format = ''
[��](fg:separator)\
$time\
[�](fg:separator)\
$hostname\
$username\
$fill\
$cmd_duration\
[�](fg:separator)\
''${custom.parents}\
$git_commit\
$git_branch\
$nix_shell\
$container\
[�](fg:separator)\
$battery\
$line_break\
[�](fg:separator)$directory$character'';
          palete = "default";
          "palettes.default" = {
            separator  = "#35312c"; #grey
            background = "#35312c"; #grey
            icon = "#161514"; #black
            accent = "#e26f31"; #orange
            success = "#6BD425"; #green
            error = "#e23140"; #red
            warning = "#8047c1"; #purple
            blue = "#5BC0EB";
          };
          time = {
            time_format = "%R";
            utc_time_offset = "-3";
            format = "[�](fg:accent)[$time](fg:$icon bg:accent)[�](fg:accent)";
          };
          hostname = {
            ssh_only = false;
            ssh_symbol = "�";
            format = "[�](fg:background)[($ssh_symbol )$hostname](bg:background)[�](fg:accent bg:background)[�](fg:icon bg:accent)[�](fg:accent bg:background)";
          };
          username = {
            show_always = true;
            style_user = "bg:background";
            style_root = "fg:warning bg:background"; 
            format = "[$username](bg:background)[�](bg:background)";
          };
          fill = {
            symbol = " ";
          };
          cmd_duration = {
            format = "[�](fg:accent)[$duration](fg:$icon bg:accent)[�](fg:accent)";
          };
          "custom.parents" = {
            command = "pwd -P | cut -d '/' -f 2,3,4";
            when = true;
            format = "[�](fg:accent)[�](fg:icon bg:accent)[�](fg:accent bg:background)[ $output](bg:background)[�](fg:background)";
          };
          git_commit = {
            tag_disabled = false;
            format = "[�](fg:separator)[�](fg:accent)[�](fg:icon bg:accent)[�](fg:accent bg:background)[ $hash$tag](bg:background)[�](fg:background)";
          };
          git_branch = {
            format = "[�](fg:separator)[�](fg:accent)[�](fg:icon bg:accent)[�](fg:accent bg:background)[ $symbol$branch(:$remote_branch)](bg:background)[�](fg:background)";
          };
          nix_shell = {
            format = "[�](fg:separator)[�](fg:accent)[�](fg:icon bg:accent)[�](fg:accent bg:background)[ $name \($state\)](bg:background)[�](fg:background)";
          };
          container = {
            format = "[�](fg:separator)[�](fg:accent)[�](fg:icon bg:accent)[�](fg:accent bg:background)[ $name](bg:background)[�](fg:background)";
          };
          battery = {
            format = "[�](fg:accent)[$symbol](fg:$style bg:accent)[$percentage]($fg:icon bg:accent)[�](fg:accent)";
          };
          "battery.display" = {
            threshold = 100;
            style = "success";
          }
          "battery.display" = {
            threshold = 50;
            style = "warning";
          }
          "battery.display" = {
            threshold = 15;
            style = "error";
          };
          directory = {
            truncation_length = 0;
            fish_style_pwd_dir_length = 0;
            truncation_symbol = "";
            truncate_to_repo = false;
            read_only = "�";
            read_only_style = "fg:icon";
            format = "[�](fg:accent)[�](fg:icon bg:accent)[�](fg:accent bg:background)[ $path( \($read_only\))](bg:background)[�](fg:background)";
          };
          character = {
            format = "$symbol[�](fg:accent)";
            success_symbol = "[�](fg:success)";
            error_symbol = "[�](fg:error)";
          };
        };
      };
    };

    environment = {
      systemPackages = with pkgs; [
        bat
        erdtree
        eza
        fishPlugins.fzf-fish
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
