{
  globals
, inputs
, nixpkgs
, ...
}:{
  imports = [
    inputs.disko.nixosModules.default
    (imports ./disko.nix { drives = builtin.elemAt globals.ultra.drives 0; })
  ];
}
