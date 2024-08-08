{ nixpkgs
, ...
}:{
  configRoot = ./.;
  customPkgs = ./pkgs;
  overlays = ./overlays;
  architectures = [ "x86_64-linux" ];
  ultra = {
    hostName = "ultra";
    userName = "ultra";
    drives = [ "/dev/sda" ];
    system = builtins.elemAt architectures 0;
  };
}
