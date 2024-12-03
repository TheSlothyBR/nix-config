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
local wezterm = require 'wezterm'
local config = {}

config.front_end = "WebGpu"

return {}
EOF
      '';
    };
  };
}
