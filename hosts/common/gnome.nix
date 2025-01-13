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
      } // config.home-manager.users.${isUser}.home.sessionVariables;
      systemPackages = let
        stable = with pkgs; [
          nautilus
        ];
        unstable = with pkgs.unstable; [
          
        ];
      in
        stable ++ unstable;
      gnome.excludePackages = with pkgs; [
        gnome-tour
        gnome-shell-extensions
      ];
    };

    services.gnome = {
      games.enable = false;
      core-utilities.enable = false;
    };

    programs = {
      gnome-terminal.enable = false;
    };

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
