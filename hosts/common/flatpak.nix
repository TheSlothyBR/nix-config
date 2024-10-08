{ inputs
, config
, pkgs
, isUser
, lib
, ...
}:{
  imports = [
    inputs.nix-flatpak.nixosModules.nix-flatpak
  ];
  
  options = {
    custom.flatpak = {
      enable = lib.mkEnableOption "Flatpak config";
    };
  };

  config = lib.mkIf config.custom.flatpak.enable {
    # only enable option is needed, rest is workaround for flatpak issue #5488
    services.flatpak = {
      enable = true;
      uninstallUnmanaged = true;
      remotes = [
        {
          name = "flathub";
          location = "https://dl.flathub.org/repo/flathub.flatpakrepo";
        }
        {
          name = "flathub-beta";
          location = "https://flathub.org/beta-repo/flathub-beta.flatpakrepo";
        }
      ];
      packages = [
        { 
          appId = "com.github.tchx84.Flatseal";
          origin = "flathub";
        }
      ];
    };

    environment.persistence."/persist" = {
      users.${isUser} = {
        directories = [
          ".var"
        ];
      };
    };

    home-manager.users.${isUser} = {
      imports = [
        inputs.nix-flatpak.homeManagerModules.nix-flatpak
      ];
      services.flatpak = {
        enable = true;
        uninstallUnmanaged = true;
        remotes = [
          {
            name = "flathub";
            location = "https://dl.flathub.org/repo/flathub.flatpakrepo";
          }
          {
            name = "flathub-beta";
            location = "https://flathub.org/beta-repo/flathub-beta.flatpakrepo";
          }
        ];
        overrides = {
          global = {
            Context.sockets = [
              "wayland"
              "!x11"
              "!fallback-x11"
            ];
          };
        };   
      };
      # Needed for desktop icons to show up due to nix-flatpak bug: #31
      xdg.systemDirs.data = [
        "/home/${isUser}/.local/share/flatpak/exports/share"
      ];
    };
  };
}
