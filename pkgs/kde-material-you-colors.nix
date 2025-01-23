{
  pkgs,
}:

pkgs.python312.pkgs.buildPythonPackage rec {
  pname = "kde-material-you-colors";
  version = "1.10.0";
  pyproject = true;

  src = pkgs.fetchFromGitHub {
    owner = "luisbocanegra";
    repo = "kde-material-you-colors";
    tag = "v${version}";
    hash = "sha256-qT2F3OtRzYagbBH/4kijuy4udD6Ak74WacIhfzaNWqo=";
  };

  build-system = [ pkgs.python312Packages.setuptools ];
  dependencies = with pkgs.python312Packages; [
    dbus-python
    numpy
    pillow
    materialyoucolor
  ];

  pythonImportsCheck = [ "kde_material_you_colors" ];

  doCheck = false;
}
