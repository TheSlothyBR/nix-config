{ pkgs
, inputs
, config
, isUser
, lib
, ...
}:{
  imports = [
    
  ];

  options = {
    custom.gnome = {
      enable = lib.mkEnableOption "Gnome Desktop config";
    };
  };

  config = lib.mkIf config.custom.gnome.enable {
    services.xserver.desktopManager.gnome.enable = true;
    
    nixpkgs.overlays = [
    
    ];

    environment.persistence."/persist" = {
      users.${isUser} = {
        directories = [
          
        ];
      };
    };

    environment = {
      sessionVariables = {
        GTK_USE_PORTAL = 1;
      };
      systemPackages = let
        stable = with pkgs; [
        
        ];
        unstable = with pkgs.unstable; [
          
        ];
      in
        stable ++ unstable;
    };

    systemd.user.sessionVariables = config.home-manager.users.${isUser}.home.sessionVariables;

    qt = {
      enable = true;
      platformTheme = "gnome";
      style = "adwaita-dark";
    };

    home-manager = {
      sharedModules  = [
      
      ];
      users.${isUser} = {
        dconf.settigs = {
          "org/gnome/desktop/background" = {
            picture-uri-dark = "file://${pkgs.nixos-artwork.wallpapers.nineish-dark-gray.src}";
          };
          "org/gnome/desktop/interface" = {
            color-scheme = "prefer-dark";
          };
        };
        gtk = {
          enable = true;
          theme = {
            name = "Adwaita-dark";
            packages = pkgs.gnome.gnome-themes-extra;
          };
        };
      };
    };
  };
}
