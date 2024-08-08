let
  architectures = [ "x86_64-linux" ];
in {
  inherit architectures;
  configRoot = ./.;
  customPkgs = ./pkgs;
  overlays = ./overlays;
  ultra = {
    hostName = "ultra";
    userName = "ultra";
    drives = [ "/dev/sda" ];
    system = builtins.elemAt architectures 0;
  };
}
