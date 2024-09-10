#!/bin/sh

config=(
  ultra
  corsair
)

NO_INSTALL=1
CORES=0
JOBS=1
export SOPS_AGE_KEY_FILE=/tmp/usb/data/secrets/keys.txt

if [[ $# -eq 0 ]]; then
  echo "Provide a Nix Flake config name, check script for options"
  exit
fi

while [[ $# -gt 0 ]]; do
  case $1 in
	-h|--help)
	  echo "Provide a Nix Flake config name, check script for options"
	  exit
	  ;;
	-f|--flake)
	  FLAKE=$2
	  shift # past argument
	  shift # past value
	  ;;
	--format-only)
	  NO_INSTALL=0
	  shift
	  ;;
	-c|--cores)
	  CORES=$2
	  shift
	  shift
	  ;;
	-j|--max-jobs)
	  JOBS=$2
	  shift
	  shift
	  ;;
	*)
	  echo "Error: no known argument provided"
	  exit 1
	  ;;
  esac
done

for config in "${configs[@]}"; do
	if [[ "$config" == "$FLAKE" ]]; then

      if grep -q "{}" "/dotfiles/hosts/${config}/system/hardware-configuration.nix"; then
        nixos-generate-config --no-filesystems --root /mnt --show-hardware-config > "/dotfiles/hosts/${config}/system/hardware-configuration.nix"
      fi

	  if [[ NO_INSTALL -eq 0 ]]; then
		nix --extra-experimental-features 'nix-command flakes' run github:nix-community/disko -- --mode disko --flake ".#${config}"
		exit
	  elif [[ ! CORES -eq 0 ]] || [[ ! JOBS -eq 1 ]]; then
		nix --extra-experimental-features 'nix-command flakes' run github:nix-community/disko -- --mode disko --flake ".#${config}"
		nixos-install --cores $CORES --max-jobs $JOBS --root /mnt --flake ".#${config}"
        #rclone copyto OneDrive:Apps/KeePassXC/s.kdbx /persist/home/Drive/Apps/KeePassXC/s.kdbx --config "/home/${config}/.config/rclone/rclone.conf"
		exit
	  else
		nix --extra-experimental-features 'nix-command flakes' run github:nix-community/disko -- --mode disko --flake ".#${config}"
		nixos-install --root /mnt --flake ".#${config}"
        #rclone copyto OneDrive:Apps/KeePassXC/s.kdbx /persist/home/Drive/Apps/KeePassXC/s.kdbx --config "/home/${config}/.config/rclone/rclone.conf"
        exit
	  fi

	else
	  echo "Error: unknown configuration provided"
	  exit 1
	fi
done
