{ lib
, stdenv
, fetchFromGitHub
, nix-update-script
}:

stdenv.mkDerivation rec {
  pname = "kde-material-you-colors-widget";
  version = "1.9.3";

  src = fetchFromGitHub {
    owner = "luisbocanegra";
    repo = "kde-material-you-colors";
    rev = "refs/tags/v${version}";
    hash = "sha256-hew+aWbfWmqTsxsNx/0Ow0WZAVl0e6OyzDxcKm+nlzQ=";
  };

  dontWrapQtApps = true;

  installPhase = ''
    runHook preInstall
    mkdir -p $out/share/plasma/plasmoids/luisbocanegra.kdematerialyou.colors
    cp -r $src/src/plasmoid/package/* $out/share/plasma/plasmoids/luisbocanegra.kdematerialyou.colors
    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };
}
