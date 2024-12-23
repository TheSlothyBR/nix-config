{ globals
, inputs
, pkgs
, ...
}:{
  imports = [
    inputs.disko.nixosModules.default
    (import ./disko.nix { inherit globals pkgs; drives = builtins.elemAt globals.ultra.drives 0; })
  ];
}
