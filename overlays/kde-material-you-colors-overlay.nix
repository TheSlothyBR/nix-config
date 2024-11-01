{ pkgs
, ...
}:{
  nixpkgs.overlays = [
    (final: prev: {
      pythonPackagesExtensions = prev.pythonPackagesExtensions ++ [
        (nfinal: nprev: {
          kde-material-you-colors = nprev.kde-material-you-colors.overrideAttrs (mfinal: mprev: {
            passthru.widget = pkgs.callPackage ../pkgs/kde-material-you-colors-widget.nix { 
              pname = mprev.pname; 
              version = mprev.version; 
              src = mprev.src; 
            };
          });
        })
      ];
    })
  ];
}
