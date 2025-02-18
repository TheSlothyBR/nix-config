{
  stdenvNoCC,
  fetchFromGitHub,
  glib,
  nix-update-script,
}:

stdenvNoCC.mkDerivation rec {
  pname = "kde-panel-spacer-extended-widget";
  version = "1.10.0";

  src = fetchFromGitHub {
    owner = "luisbocanegra";
    repo = "plasma-panel-spacer-extended";
    rev = "refs/tags/v${version}";
    hash = "sha256-Rr80bI+9xnrlj8JNTL+vGqOw9/98R0ub0pQfHQmEWNM=";
  };

  propagatedUserEnvPkgs = [
    glib
  ];

  dontBuild = true;

  dontWrapQtApps = true;

  installPhase = ''
    runHook preInstall
    mkdir -p $out/share/plasma/plasmoids/luisbocanegra.panelspacer.extended
    cp -r $src/package/* $out/share/plasma/plasmoids/luisbocanegra.panelspacer.extended
    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };
}
