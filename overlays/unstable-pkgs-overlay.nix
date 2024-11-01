{ inputs
, ...
}:{
  nixpkgs.overlays = [
    (final: prev: {
      unstable = import inputs.nixpkgs-unstable {
        system = final.system;
      };
    })
  ];
}
