{
  stdenvNoCC,
  fetchFromGitHub,
  nix-update-script,
}:

stdenvNoCC.mkDerivation rec {
  pname = "kde-material-you-colors-widget";
  version = "1.10.0";

  src = fetchFromGitHub {
    owner = "luisbocanegra";
    repo = "kde-material-you-colors";
    rev = "refs/tags/v${version}";
    hash = "sha256-qT2F3OtRzYagbBH/4kijuy4udD6Ak74WacIhfzaNWqo=";
  };

  dontBuild = true;

  dontWrapQtApps = true;

  installPhase = ''
    runHook preInstall
    mkdir -p $out/share/plasma/plasmoids/luisbocanegra.kdematerialyou.colors
    cp -r $src/src/plasmoid/package/* $out/share/plasma/plasmoids/luisbocanegra.kdematerialyou.colors
    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };
}
