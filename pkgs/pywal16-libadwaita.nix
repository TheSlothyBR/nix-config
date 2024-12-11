{ lib
, stdenvNoCC
, fetchFromGitHub
, nix-update-script
}:

stdenvNoCC.mkDerivation rec {
  pname = "pywal16-libadwaita";
  version = "unstable-2024-12-10";

  src = fetchFromGitHub {
    owner = "eylles";
    repo = "${pname}";
    rev = "c1bc34ca8aae8a13501e64ca50eb715aeca74121";
    hash = "sha256-w8EhFnzZqaujASSUrPBs+gHfHRcvpbcOQv7aBFfcdws=";
  };

  dontBuild = true;

  installPhase = ''
    runHook preInstall
    mkdir -p $out/share/wal/templates
    cp -r $src/templates/* $out/share/wal/templates
    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };
}
