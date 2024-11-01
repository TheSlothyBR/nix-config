{ lib
, stdenv
, cmake
, extra-cmake-modules
, libplasma
, plasma
, pname
, version
, src
}:

stdenv.mkDerivation rec {
  pname = "${pname}-widget";
  inherit version src;

  nativeBuildInputs = [
    cmake
    extra-cmake-modules
  ];

  buildInputs = [
    libplasma
    plasma
  ];

  dontWrapQtApps = true;
  cmakeFlags = [ "-DINSTALL_PLASMOID=ON" ];
};
