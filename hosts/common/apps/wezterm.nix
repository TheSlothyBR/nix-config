{
  isUser,
  config,
  lib,
  pkgs,
  ...
}:
{
  options = {
    custom.wezterm = {
      enable = lib.mkEnableOption "Wezterm config";
    };
  };

  config = lib.mkIf config.custom.wezterm.enable {
    environment.systemPackages = with pkgs; [
      wezterm
    ];

    systemd.services."generate-wezterm-config" = {
      description = "Generate Wezterm Config";
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        Type = "oneshot";
        User = "${isUser}";
        Group = "users";
      };
      script = ''
                 mkdir -p ~/.config/wezterm
                 cat << 'EOF' > ~/.config/wezterm/wezterm.lua
        local wezterm = require("wezterm")
        local config = wezterm.config_builder()
        -- local colors = dofile(os.getenv("HOME") .. "/<path>/<to>/<name>.lua")

        config = {
          enable_tab_bar = true,
          front_end = "WebGpu",
          enable_kitty_graphics = true,
          max_fps = 60,
          window_padding = {
            left = 2,
            right = 2,
            top = 15,
            bottom = 0,
          },
          font_size = 11.0,
          window_background_opacity = 0.8,
          use_fancy_tab_bar = false,
          hide_tab_bar_if_only_one_tab = true,
          colors = {
            tab_bar = {
              background = "rgba(0,0,0,0.8)",
        --    active_tab = {
        --      bg_color = "rgba(0,0,0,1)",
        --      fg_color = "white",
        --    },
        --    new_tab = {
        --      bg_color = "rgba(0,0,0,1)",
        --      fg_color = "white",
        --    },
            };
          },
        }

        return config
        EOF
      '';
    };
  };
}
