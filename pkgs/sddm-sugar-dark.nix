{ stdenvNoCC
, fetchFromGitHub
}: {
  sddm-sugar-dark = stdenvNoCC.mkDerivation rec {
    pname = "sddm-sugar-dark-theme";
    version = "1.2";
    src = fetchFromGitHub {
      owner = "MarianArlt";
      repo = "sddm-sugar-dark";
      rev = "v${version}";
      sha256 = "0gx0am7vq1ywaw2rm1p015x90b75ccqxnb1sz3wy8yjl27v82yhb";
    };

    dontBuild = true;
    
    installPhase = ''
      mkdir -p $out/share/sddm/themes
      cp -aR $src $out/share/sddm/themes/sugar-dark
    '';
  };
}
