let
  architectures = [ "x86_64-linux" ];
in {
  meta = {
    inherit architectures;
    owner = "TheSlothyBR";
    repo = "nix-config";
    flakePath = "/etc/nixos/dotfiles";
    usb = "/dev/disk/by-id/usb-Kingston_DT_101_G2_0018F30CA1A8BD30F17B0199-0:0-part1";
    lvmPool = "pool";
    lvmLogicalSystem = "system";
  };
  ultra = {
    hostName = "ultra";
    userName = "ultra";
    drives = [ "/dev/sda" ];
    system = builtins.elemAt architectures 0;
  };
  corsair = {
    hostName = "corsair";
    userName = "corsair";
    drives = [ "/dev/sda" "/dev/sdb" ];
    system = builtins.elemAt architectures 0;
  };
  customIso = {
    hostName = "customIso";
    userName = "customIso";
    drives = [];
    system = builtins.elemAt architectures 0;
  };
}
