rec {
  meta = {
    architectures = [ "x86_64-linux" ];
    owner = "TheSlothyBR";
    repo = "nix-config";
    flakePath = ".dotfiles";
    usb = "/dev/disk/by-id/usb-Kingston_DT_101_G2_0018F30CA1A8BD30F17B0199-0:0-part1";
    lvmPool = "pool";
    lvmLogicalSystem = "system";
  };
  ultra = {
    hostName = "ultra";
    userName = "ultra";
    drives = [ "/dev/sda" ];
    system = builtins.elemAt meta.architectures 0;
	  persistFlakePath = "/persist/home/${corsair.userName}";
  };
  corsair = {
    hostName = "corsair";
    userName = "corsair";
    drives = [ "/dev/sda" "/dev/sdb" ];
    system = builtins.elemAt meta.architectures 0;
	  persistFlakePath = "/persist/home/${corsair.userName}";
  };
  customIso = {
    hostName = "customIso";
    userName = "customIso";
    drives = [];
    system = builtins.elemAt meta.architectures 0;
	  persistFlakePath = "/etc/nixos/${meta.flakePath}";
  };
}
