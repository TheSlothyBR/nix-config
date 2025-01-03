{ isUser
, config
, lib
, pkgs
, ...
}:{
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
  front_end = "WebGpu",
  enable_kitty_graphics = true,
  max_fps = 60,
  -- window_close_confirmation = "NeverPrompt",
  -- font = wezterm.font("<nameHere>"),
  window_padding = {
    left = 2,
    right = 2,
    top = 15,
    bottom = 0,
  },
  -- colors = {},
}

return config
EOF
      '';
    };
  };
}
