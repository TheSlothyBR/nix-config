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
  config = {
    environment.systemPackages = with pkgs; [
      brave
    ];
  };
}
