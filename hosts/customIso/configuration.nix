{
  pkgs,
  modulesPath,
  config,
  globals,
  ...
}:
{
  imports = [
    "${modulesPath}/installer/cd-dvd/installation-cd-minimal.nix"
  ];

  nixpkgs = {
    hostPlatform = builtins.elemAt globals.meta.architectures 0;
    config.allowUnfree = true;
  };

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  isoImage.squashfsCompression = "gzip -Xcompression-level 1";

  boot = {
    kernelPackages = pkgs.linuxKernel.packages.linux_6_14;
  };

  hardware.enableAllFirmware = true;

  environment.systemPackages = with pkgs; [
    neovim
    git
    age
    git
    sops
    ssh-to-age
    curl
    fsarchiver
    lm_sensors
    (pkgs.writeShellApplication {
      name = "install";
      runtimeInputs = [ ];
      text = ''
        nix run github:${globals.meta.owner}/${globals.meta.repo} -- "$@"
      '';
    })
    (pkgs.writeShellApplication {
      name = "wipe";
      runtimeInputs = [ ];
      text = ''
        mount -o remount,size=2G,noatime /nix/.rw-store
        swapoff /dev/zram0 ||:
        modprobe -r zram
        echo 1 > /sys/module/zswap/parameters/enabled
        umount -A /tmp/usb
        unset SOPS_AGE_KEY_FILE
        rm -rf /{dotfiles,tmp/usb,tmp/*{.age,_key,_key.pub}}
      '';
    })
  ];
}
