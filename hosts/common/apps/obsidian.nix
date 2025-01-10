{ config
, isUser
, lib
, ...
}:{
  options = {
    custom.obsidian = {
      enable = lib.mkEnableOption "Obsidian.md config";
      autostart = lib.mkEnableOption "Autostart Obsidian";
    };
  };

  config = lib.mkIf config.custom.obsidian.enable {
    home-manager.users.${isUser} = {
      services.flatpak = {
        packages = [
          {
            appId = "md.obsidian.Obsidian";
            origin = "flathub";
          }
        ];
		overrides = {
          "md.obsidian.Obsidian" = {
            Context = {
              filesystems = [
                "~/Drive/ObsidianVault:rw"
              ];
            };
          };
        };
      };
    };

    systemd.services."generate-obsidian-autostart" = lib.mkIf config.custom.obsidian.autostart {
      description = "Generate Obsidian Autostart";
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        Type = "oneshot";
        User = "${isUser}";
        Group = "users";
      };
      script = ''
        mkdir -p ~/.config/autostart
        cat << 'EOF' > ~/.config/autostart/md.obsidian.Obsidian.desktop
[Desktop Entry]
Categories=Office;
Comment=Obsidian
Exec=flatpak run --branch=stable --arch=x86_64 --command=obsidian.sh --file-forwarding md.obsidian.Obsidian @@u %U @@
Icon=md.obsidian.Obsidian
MimeType=x-scheme-handler/obsidian;
Name=Obsidian
StartupWMClass=obsidian
Terminal=false
Type=Application
X-Flatpak=md.obsidian.Obsidian
X-Flatpak-Tags=proprietary;
      '';
    };

    environment.persistence."/persist" = {
      users.${isUser} = {
        directories = [
          ".var/app/md.obsidian.Obsidian"
        ];
      };
    };
  };
}
