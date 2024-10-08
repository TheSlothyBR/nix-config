{ inputs
, config
, isUser
, pkgs
, lib
, ...
}:{
  options = {
    custom.brave = {
      enable = lib.mkEnableOption "Brave Browser config";
    };
  };

  config = lib.mkIf config.custom.brave.enable {
   # inputs.home-manager.users.${isUser} = {
   #   services.flatpak.packages = [
   #     {
   #       appId = "com.brave.Browser";
   #       origin = "flathub";
   #     }
   #   ];
   # };
    environment.systemPackages = with pkgs; [
      brave
    ];
    
    environment.persistence."/persist" = {
      users.${isUser} = {
        directories = [
          ".config/BraveSoftware/Brave-Browser/Default/Extensions"
        ];
        files = [
          ".config/BraveSoftware/Brave-Browser/Default/Preferences"
          ".config/BraveSoftware/Brave-Browser/Local State"
        ];
      };
    };
  };
}
