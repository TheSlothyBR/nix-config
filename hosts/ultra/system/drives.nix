{ globals
, inputs
, nixpkgs
, ...
}:{
  imports = [
    inputs.disko.nixosModules.default
    (import ./disko.nix { inherit globals; drives = builtins.elemAt globals.ultra.drives 0; })
  ];
}
