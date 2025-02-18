{
  config,
  isUser,
  lib,
  ...
}:
{
  options = {
    custom.chrome = {
      enable = lib.mkEnableOption "Chrome config";
    };
  };

  config = lib.mkIf config.custom.chrome.enable {
    home-manager.users.${isUser} = {
      services.flatpak = {
        packages = [
          {
            appId = "com.google.Chrome";
            origin = "flathub";
          }
        ];
      };
    };

    environment.persistence."/persist" = {
      users.${isUser} = {
        directories = [
          ".var/app/com.google.Chrome"
        ];
      };
    };
  };
}
