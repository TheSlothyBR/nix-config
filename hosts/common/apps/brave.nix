{ inputs
, globals
, pkgs
, ...
}:{
 # inputs.home-manager.users.${globals.ultra.userName} = {
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
    users.${globals.ultra.userName} = {
      directories = [
        ".config/BraveSoftware/Brave-Browser/Default/Extensions"
      ];
      files = [
        ".config/BraveSoftware/Brave-Browser/Default/Preferences"
        ".config/BraveSoftware/Brave-Browser/Local State"
      ];
    };
  };
}
