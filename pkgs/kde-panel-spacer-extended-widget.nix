{ lib
, stdenv
, fetchFromGitHub
, glib
, nix-update-script
}:

stdenv.mkDerivation rec {
  pname = "kde-panel-spacer-extended-widget";
  version = "1.9.0";

  src = fetchFromGitHub {
    owner = "luisbocanegra";
    repo = "plasma-panel-spacer-extended";
    rev = "refs/tags/v${version}";
    hash = "sha256-3ediynClboG6/dBQTih6jJPGjsTBZhZKOPQAjGLRNmk=";
  };

  propagatedUserEnvPkgs = [
    glib
  ];

  dontWrapQtApps = true;

  installPhase = ''
    runHook preInstall
    mkdir -p $out/share/plasma/plasmoids/luisbocanegra.panelspacer.extended
    cp -r $src/package/* $out/share/plasma/plasmoids/luisbocanegra.panelspacer.extended
    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };
}
