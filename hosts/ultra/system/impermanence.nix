{ inputs
, globals
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
          "systemd-cryptsetup@ultra.service"
        ];
        before = [ "sysroot.mount" ];
        unitConfig.DefaultDependencies = "no";
        serviceConfig.Type = "oneshot";
        script = ''
          MNTPOINT=$(mktemp -d)
          (
            mount -t btrfs -o subvol=/ /dev/pool/system "$MNTPOINT"
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
      "/etc/nixos"
      "/etc/secureboot"
      "/etc/NetworkManager/system-connections"
      "/etc/ssh"
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
    users.${globals.ultra.userName} = {
      directories = [
        ".local/share"
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
    DRIVE = "$HOME/Drive";
    GAMES = "$HOME/Games";
  };

  programs.fuse.userAllowOther = true;

  home-manager.users.${globals.ultra.userName} = {
    imports = [
      inputs.impermanence.nixosModules.home-manager.impermanence
    ];
    home.persistence."/persist/home/${globals.ultra.userName}" = {
      #directories = [
      #  { directory = ".local/share/Steam"; method = "symlink"; }
      #];
      allowOther = true;
    };
  };
}
