let
  architectures = [ "x86_64-linux" ];
in {
  meta = {
    inherit architectures;
  };
  ultra = {
    hostName = "ultra";
    userName = "ultra";
    drives = [ "/dev/sda" ];
    system = builtins.elemAt architectures 0;
  };
  customIso = {
    hostName = "customIso";
    userName = "customIso";
    drives = [];
    system = builtins.elemAt architectures 0;
  };
}
