{ stdenv
, fetchurl
, meson
, ninja
, glib
, cmake
, pkg-config
}:stdenv.mkDerivation (self: {
  pname = "flatpak-xdg-utils";
  version = "1.0.6";

  src = fetchurl {
    url = "https://github.com/flatpak/flatpak-xdg-utils/releases/download/${self.version}/flatpak-xdg-utils-${self.version}.tar.xz";
    sha256 = "53705e4cfe81460d8cf6be6ce1b1f6a79c9d12b27b6fd6c6b8d48f6a863a17ff";
  };

  nativeBuildInputs = [
    meson
    ninja
    glib
    cmake
    pkg-config
  ];
})
