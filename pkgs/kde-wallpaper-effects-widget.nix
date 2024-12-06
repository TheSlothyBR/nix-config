{ lib
, stdenv
, fetchFromGitHub
, nix-update-script
}:

stdenv.mkDerivation rec {
  pname = "kde-wallpaper-effects-widget";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "luisbocanegra";
    repo = "plasma-wallpaper-effects";
    rev = "refs/tags/v${version}";
    hash = "sha256-pZiPH38E9CSaBOnutZM/QeQnst6Ppvxhd4An+n21vr8=";
  };

  dontWrapQtApps = true;

  installPhase = ''
    runHook preInstall
    mkdir -p $out/share/plasma/plasmoids/luisbocanegra.desktop.wallpaper.effects
    cp -r $src/package/* $out/share/plasma/plasmoids/luisbocanegra.desktop.wallpaper.effects
    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };
}
