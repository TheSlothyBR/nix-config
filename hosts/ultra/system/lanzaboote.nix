{ inputs
, nixpkgs
, lib
, ...
}:{
 # imports = [
 #   inputs.lanzaboote.nixosModules.lanzaboote
 # ];

 # boot = {
 #   loader.systemd-boot.enable = lib.mkForce false;
 #   lanzaboote = {
 #     enable = true;
 #     pkiBundle = "/etc/secureboot";
 #   };
 # };
}
