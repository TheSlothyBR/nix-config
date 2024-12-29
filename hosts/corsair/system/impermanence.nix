{ inputs
, globals
, isConfig
, isUser
, ...
}:{
  
  imports = [
    inputs.impermanence.nixosModules.impermanence
  ];

  boot.initrd = {
    supportedFilesystems = [ "btrfs" ];
    systemd = {
      enable = true;
      services."wipe-root" = {
        description = "Impermanence root wipe";
        wantedBy = [ "initrd.target" ];
        requires = [ "dev-pool-system.device" ];
        after = [
          "dev-pool-system.device"
          "systemd-cryptsetup@${isConfig}.service"
        ];
        before = [ "sysroot.mount" ];
        unitConfig.DefaultDependencies = "no";
        serviceConfig.Type = "oneshot";
        script = ''
          MNTPOINT=$(mktemp -d)
          (
            mount -t btrfs -o subvol=/ /dev/${globals.meta.lvmPool}/${globals.meta.lvmLogicalSystem} "$MNTPOINT"
            trap 'umount "$MNTPOINT"' EXIT

            btrfs subvolume list -o "$MNTPOINT/root" | cut -f9 -d ' ' |
            while read -r subvolume; do
              btrfs subvolume delete "$MNTPOINT/$subvolume"
            done && btrfs subvolume delete "$MNTPOINT/root"
            btrfs subvolume snapshot "$MNTPOINT/snapshots/blank-root" "$MNTPOINT/root"
          )
        '';
      };
    };
  };

  fileSystems."/persist".neededForBoot = true;

  environment.persistence."/persist/system" = {
    hideMounts = true;
    directories = [
      "/etc/secureboot"
      "/etc/NetworkManager/system-connections"
      "/var/log"
      "/var/lib/bluetooth"
      "/var/lib/nixos"
      "/var/lib/systemd/coredump"
    ];
    files = [
      "/etc/machine-id"
    ];
  };

  environment.persistence."/persist" = {
    hideMounts = true;
    users.${isUser} = {
      directories = [
        "${globals.meta.flakePath}"
        "Desktop"
        "Documents"
        "Downloads"
        "Drive"
        "Games"
        "Music"
        "Pictures"
        "Public"
        "Templates"
        "Videos"
      ];
    };
  };

  environment.sessionVariables = {
    DRIVE = "/home/${isUser}/Drive";
    GAMES = "/home/${isUser}/Games";
  };

  programs.fuse.userAllowOther = true;

  home-manager.users.${isUser} = {
    imports = [
      inputs.impermanence.nixosModules.home-manager.impermanence
    ];
    home.persistence."/persist/home/${isUser}" = {
      allowOther = true;
    };
  };
}
