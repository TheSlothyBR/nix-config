{ pkgs
, ...
}:{
  nixpkgs.overlays = [
    (final: prev: {
      colloid-kde = prev.colloid-kde.overrideAttrs (nprev: rec {
	version = "unstable-2024-09-28";

	src = pkgs.fetchFromGitHub {
          owner = "vinceliuice";
	  repo = nprev.repo;
	  rev = "950da0fa52634f9414df351fab033073ab9c7b0b";
	  hash = "sha256-6qj28jj2Zqx61bClf9OYHA+RUTBj+6oQ4DmfimOlIKQ=";
	};
      });
    })
  ];
}
