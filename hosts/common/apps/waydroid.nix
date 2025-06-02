{
  config,
  lib,
  isUser,
  ...
}:
{
  options = {
    custom.waydroid = {
      enable = lib.mkEnableOption "Waydroid configs";
    };
  };

  config = lib.mkIf config.custom.waydroid.enable {
    virtualisation.waydroid.enable = true;

    environment.persistence."/persist/system" = {
      directories = [
        "/var/lib/waydroid"
      ];
    };

    environment.persistence."/persist" = {
      users.${isUser} = {
        directories = [
          ".local/share/waydroid"
        ];
      };
    };
  };
}
