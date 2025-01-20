{
  config,
  isUser,
  lib,
  ...
}:
{
  options = {
    custom.gnomeExtensionManager = {
      enable = lib.mkEnableOption "GNOME Extension Manager config";
    };
  };

  config = lib.mkIf config.custom.gnomeExtensionManager.enable {
    home-manager.users.${isUser} = {
      services.flatpak = {
        packages = [
          {
            appId = "com.mattjakeman.ExtensionManager";
            origin = "flathub";
          }
        ];
      };
    };

    environment.persistence."/persist" = {
      users.${isUser} = {
        directories = [
          "./var/app/com.mattjakeman.ExtensionManager"
        ];
      };
    };
  };
}
