{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  kdePackages,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "plasma-panel-colorizer";
  version = "2.1.0";

  src = fetchFromGitHub {
    owner = "luisbocanegra";
    repo = "plasma-panel-colorizer";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Xv1yGIGIWqfxukJub0X2sH0XwtRTr13p+vDi+Wdgnkg=";
  };

  nativeBuildInputs = [
    cmake
    kdePackages.extra-cmake-modules
  ];

  buildInputs = [
    kdePackages.plasma-desktop
  ];

  strictDeps = true;

  cmakeFlags = [
    (lib.cmakeBool "INSTALL_PLASMOID" true)
    (lib.cmakeBool "BUILD_PLUGIN" true)
    (lib.cmakeFeature "Qt6_DIR" "${kdePackages.qtbase}/lib/cmake/Qt6")
  ];

  dontWrapQtApps = true;

  passthru.updateScript = nix-update-script { };

})
