{
  inputs
, globals
, nixpkgs
, ...
}:{
  
  imports = [
    inputs.impermanence.nixosModules.impermanence
  ];

  home-manager.users.${globals.ultra.userName} = {
    imports = [
      inputs.impermanence.nixosModules.home-manager.impermanence
    ];
  };

  boot.initrd = {
    supportedFilesystems = ["btrfs"];
    systemd = {
      enable = true;
      services."wipe-root" = {
        description = "Impermanence root wipe";
        wantedBy = ["initrd.target"];
        requires = ["dev-disk-by\\x2dlabel-crypted.device"];
        after = [
          "dev-disk-by\\x2dlabel-crypted.device"
          "systemd-cryptsetup@$crypted.service"
        ];
        before = ["sysroot.mount"];
        unitConfig.DefaultDependencies = "no";
        serviceConfig.Type = "oneshot";
        script = ''
          MNTPOINT=$(mktemp -d)
          (
            mount -t btrfs -o subvol=/ /dev/mapper/pool-system "$MNTPOINT"
            trap 'umount "$MNTPOINT"' EXIT

            btrfs subvolume list -o "$MNTPOINT/root" | cut -f9 -d ' ' |
            while read -r subvolume; do
              btrfs subvolume delete "$MNTPOINT/$subvolume"
            done && btrfs subvolume delete "$MNTPOINT/root"
            btrfs subvolume snapshot "$MNTPOINT/.snapshots/blank-root" "$MNTPOINT/root"
          )
        '';
      };
    };
  };

  systemd = {
    tmpfiles.settings = {
      "enforce-impermanence-home" = {
        "/persist/home" = {
          d = {
            group = "wheel";
            user = "root";
            mode = "0755";
          };
        };
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
      "/var/log"
      "/var/lib/bluetooth"
      "/var/lib/nixos"
      "/var/lib/systemd/coredump"
    ];
    files = [
      "/etc/machine-id"
    ];
  };

  home.persistence."/persist/home" = {
    directories = [
      "Documents"
      "Downloads"
      "Music"
      "Pictures"
      "Videos"
      ".gnupg"
      ".ssh"
      ".local/share/keyrings"
      ".local/share/direnv"
	  {
	    directory = ".local/share/Steam";
		method = "symlink";
	  }
	];
	files = [
	  ".screenrc"
	];
	allowOther = true;
  };
}
