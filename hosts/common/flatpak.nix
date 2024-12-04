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
    environment.persistence."/persist/system" = {
      directories = [
        "/var/lib/flatpak"
      ];
    };
    
    systemd.services."flatpak-managed-install" = {
      serviceConfig = {
        ExecStartPre = "${pkgs.networkmanager}/bin/nm-online -q -t 90";
      };
    };

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
            Environment = {
              XCURSOR_PATH = "/run/host/user-share/icons:/run/host/share/icons";
              GTK_USE_PORTAL = "1";
              #GTK_THEME = "Adwaita:dark";
            };
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
