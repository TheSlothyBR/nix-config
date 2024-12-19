{ config
, lib
, pkgs
, ...
}:{
  options = {
    custom.vm = {
      enable = lib.mkEnableOption "VMs configs";
    };
  };

  config = lib.mkIf config.custom.vm.enable {
    environment.systemPackages = with pkgs; [
      virt-manager
      virt-viewer
      win-virtio
      #spice
      #spice-protocol
      #win-spice
    ];

    virtualization = {
      libvirtd = {
        enable = true;
        qemu = {
          swtpm.enable = true;
          ovmf.enable = true;
        };
      };
      #spiceUSBRedirection.enable = true;
    };
    #service.spice-vdagentd.enable = true;
  };
}
