{
  config,
  isUser,
  pkgs,
  lib,
  ...
}:
{
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
          zoxide init fish | source
          function fish_greeting
            if type -q fastfetch
              fastfetch
            end
          end
        '';
      };
      starship = {
        enable = true;
        settings = {
          add_newline = false;
          command_timeout = 5000;
          format = ''
            [╭](fg:separator)$hostname''${custom.username}[─](fg:separator)$time$fill''${custom.parents}$git_branch$nix_shell$container[─](fg:separator)$battery$line_break[╰](fg:separator)''${custom.directory}$character
          '';
          palette = "default";
          palettes = {
            default = {
              separator = "#35312c"; # grey
              background = "#35312c"; # grey
              icon = "#161514"; # black
              accent = "#e26f31"; # orange
              success = "#6BD425"; # green
              error = "#e23140"; # red
              warning = "#8047c1"; # purple
              blue = "#5BC0EB";
            };
          };
          time = {
            disabled = false;
            time_format = "%R";
            utc_time_offset = "-3";
            format = "[](fg:accent)[ $time](accent)";
          };
          hostname = {
            ssh_only = false;
            ssh_symbol = "󰴽";
            format = "[](fg:background)[($ssh_symbol )$hostname](bg:background)[](fg:accent bg:background)[󰹻](fg:icon bg:accent)[](fg:accent bg:background)";
          };
          fill = {
            symbol = " ";
          };
          cmd_duration = {
            format = "[](fg:accent)[$duration](fg:$icon bg:accent)[](fg:accent)[─](fg:separator)";
          };
          custom = {
            parents = {
              command = "pwd -P | cut -d '/' -f 2,3,4";
              when = true;
              format = "[](fg:accent)[](fg:icon bg:accent)[](fg:accent bg:background)[ $output](bg:background)[](fg:background)";
            };
            username = {
              command = "whoami";
              when = true;
              format = "[$output](bg:background)[](fg:background)";
            };
            directory = {
              command = "pwd -P | xargs basename";
              when = true;
              format = "[](fg:accent)[](fg:icon bg:accent)[](fg:accent bg:background)[ $output](bg:background)[](fg:background)";
            };
          };
          git_branch = {
            format = "[─](fg:separator)[](fg:accent)[](fg:icon bg:accent)[](fg:accent bg:background)[ $symbol$branch(:$remote_branch)](bg:background)[](fg:background)";
          };
          nix_shell = {
            format = "[─](fg:separator)[](fg:accent)[](fg:icon bg:accent)[](fg:accent bg:background)[ $name \($state\)](bg:background)[](fg:background)";
          };
          container = {
            format = "[─](fg:separator)[](fg:accent)[](fg:icon bg:accent)[](fg:accent bg:background)[ $name](bg:background)[](fg:background)";
          };
          battery = {
            format = "[](fg:accent)[$symbol](fg:$style bg:accent)[](fg:accent)";
            display = [
              {
                threshold = 100;
                style = "success";
              }
              {
                threshold = 50;
                style = "warning";
              }
              {
                threshold = 15;
                style = "error";
              }
            ];
          };
          character = {
            format = " $symbol [󰅂](fg:accent) ";
            success_symbol = "[](fg:success)";
            error_symbol = "[](fg:error)";
          };
        };
      };
    };

    systemd.services."generate-fastfetch-config" = {
      description = "Generate Fastfetch Config";
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        Type = "oneshot";
        User = "${isUser}";
        Group = "users";
      };
      script = ''
        #mkdir -p ~/.config/fastfetch
        #cat << 'EOF' > ~/.config/fastfetch/config.jsonc
        #EOF
      '';
    };

    environment = {
      systemPackages = with pkgs; [
        bat
        erdtree
        eza
        fastfetch
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
