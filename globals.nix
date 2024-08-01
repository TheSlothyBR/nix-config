{
  configRoot = ./.;
  customPkgs = ./pkgs;
  overlays = ./overlays;
  ultra = {
    hostName = "ultra";
    userName = "ultra";
    drives = [ "/dev/sda" ];
    system = "x86_64-linux";
  };
}
