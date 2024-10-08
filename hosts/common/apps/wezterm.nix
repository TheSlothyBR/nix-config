{ isUser
, config
, lib
, ...
}:{
  options = {
    custom.wezterm = {
      enable = lib.mkEnableOption "Wezterm config";
    };
  };

  config = lib.mkIf config.custom.wezterm.enable {
    home-manager.users.${isUser} = {
      programs = {
        wezterm = {
          enable = true;
          enableBashIntegration = true;
        };
      };
    };
  };
}
