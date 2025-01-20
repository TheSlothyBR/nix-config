{
  config,
  isUser,
  lib,
  ...
}:
{
  options = {
    custom.flatsweep = {
      enable = lib.mkEnableOption "Flatsweep config";
    };
  };

  config = lib.mkIf config.custom.flatsweep.enable {
    home-manager.users.${isUser} = {
      services.flatpak = {
        packages = [
          {
            appId = "io.github.giantpinkrobots.flatsweep";
            origin = "flathub";
          }
        ];
      };
    };

    environment.persistence."/persist" = {
      users.${isUser} = {
        directories = [
          "./var/app/io.github.giantpinkrobots.flatsweep"
        ];
      };
    };
  };
}
