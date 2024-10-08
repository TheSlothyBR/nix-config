{ pkgs
, ...
}:{
  nixpkgs.overlays = [
    (final: prev: {
      colloid-kde = prev.colloid-kde.overrideAttrs (nfinal: nprev: {
	version = "unstable-2024-09-28";

	src = pkgs.fetchFromGitHub {
          owner = "vinceliuice";
	  repo = "colloid-kde";
	  rev = "950da0fa52634f9414df351fab033073ab9c7b0b";
	  hash = "sha256-6qj28jj2Zqx61bClf9OYHA+RUTBj+6oQ4DmfimOlIKQ=";
	};
        
	postPatch = ''
          patchShebangs install.sh
          patchShebangs sddm/6.0/install.sh

	  substituteInPlace install.sh \
	    --replace '$HOME/.local' $out \
	    --replace '$HOME/.config' $out/share \
	
	  substituteInPlace sddm/6.0/install.sh \
	    --replace /usr $sddm \
	    --replace '$(cd $(dirname $0) && pwd)' . \
	    --replace '"$UID" -eq "$ROOT_UID"' true
	
	  substituteInPlace sddm/6.0/Colloid/Main.qml \
	    --replace /usr $sddm
	'';

        installPhase = ''
          runHook preInstall

          mkdir -p $out/share/latte

          name= HOME="$TMPDIR" \
	  ./install.sh --dest $out/share/themes

          mkdir -p $sddm/share/sddm/themes

	  cd sddm/6.0
	  ./install.sh --dest $sddm/share/sddm/themes

          runHook postInstall
	'';
      });
    })
  ];
}
