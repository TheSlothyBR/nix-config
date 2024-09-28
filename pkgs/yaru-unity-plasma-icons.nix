{ stdenvNoCC
, fetchFromGitHub
}:stdenvNoCC.mkDerivation rec {
  name = "yaru-unity-for-kde";
  src = fetchFromGitHub {
    owner = "zayronxio";
    repo = "yaru-unity-for-KDE";
    rev = "cdada2c0853bfddc35c572f8a363dc5b441455f6";
    sha256 = "0ch39i2aq50fra2chb2rn8m1zq8q23ik5bg6ap3551bbb88m5pg8";
  };

  dontBuild = true;
  
  installPhase = ''
    mkdir -p $out/share/icons/YaruPlasma-Dark
    cp -aR $src/icons/YaruPlasma-Dark/* $out/share/icons/YaruPlasma-Dark
  '';
}
