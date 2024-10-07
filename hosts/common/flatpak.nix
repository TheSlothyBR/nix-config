{ inputs
, pkgs
, globals
, ...
}:{
 # # only enable option is needed, rest is workaround for flatpak issue #5488
 # imports = [
 #   inputs.nix-flatpak.nixosModules.nix-flatpak
 # ];
 # services.flatpak = {
 #   enable = true;
 #   uninstallUnmanaged = true;
 #   remotes = [
 #     {
 #       name = "flathub";
 #       location = "https://dl.flathub.org/repo/flathub.flatpakrepo";
 #     }
 #     {
 #       name = "flathub-beta";
 #       location = "https://flathub.org/beta-repo/flathub-beta.flatpakrepo";
 #     }
 #   ];
 #   packages = [
 #     { 
 #       appId = "com.github.tchx84.Flatseal";
 #       origin = "flathub";
 #     }
 #   ];
 # };

 # environment.persistence."/persist" = {
 #   users.${globals.ultra.userName} = {
 #     directories = [
 #       ".var"
 #     ];
 #   };
 # }

 # home-manager.users.${globals.ultra.userName} = {
 #   imports = [
 #     inputs.nix-flatpak.homeManagerModules.nix-flatpak
 #   ];
 #   services.flatpak = {
 #     enable = true;
 #     uninstallUnmanaged = true;
 #     remotes = [
 #       {
 #         name = "flathub";
 #         location = "https://dl.flathub.org/repo/flathub.flatpakrepo";
 #       }
 #       {
 #         name = "flathub-beta";
 #         location = "https://flathub.org/beta-repo/flathub-beta.flatpakrepo";
 #       }
 #     ];
 #     overrides = {
 #       global = {
 #         Context.sockets = [
 #           "wayland"
 #           "!x11"
 #           "!fallback-x11"
 #         ];
 #       };
 #     };   
 #   };
 #   # Needed for desktop icons to show up due to nix-flatpak bug: #31
 #   xdg.systemDirs.data = [
 #     "/home/${globals.ultra.userName}/.local/share/flatpak/exports/share"
 #   ];
 # };
}
