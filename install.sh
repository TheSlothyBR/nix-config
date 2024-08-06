#!/usr/bin/env bash

set -e

configs=(
  ultra
)

NO_INSTALL=1
CORES=0
JOBS=1

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
    --cores)
      CORES=$2
      shift
      shift
      ;;
    --max-jobs)
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

for config in $configs; do
    if [[ "$config" == "$FLAKE" ]]; then

     #if [[ ! -f ./flake.lock ]]; then
     #  nix --extra-experimental-features 'nix-command flakes' flake lock
     #  git add .
     #elif grep -q "string" "./hosts/${config}/system/hardware-configuration.nix"; then
     #  nixos-generate-config --no-filesystems --root /mnt --show-hardware-config > "./hosts/${config}/system/hardware-configuration.nix"
     #  git add .
     #fi

      if [[ NO_INSTALL -eq 0 ]]; then
        nix --extra-experimental-features 'nix-command flakes' run github:nix-community/disko -- --mode disko --flake ".#${config}"
        exit
      elif [[ ! CORES -eq 0 ]] || [[ ! JOBS -eq 1 ]]; then
        nix --extra-experimental-features 'nix-command flakes' run github:nix-community/disko -- --mode disko --flake ".#${config}"
        nixos-install --cores $CORES --max-jobs $JOBS --root /mnt --flake ".#${config}"
        exit
      else
        nix --extra-experimental-features 'nix-command flakes' run github:nix-community/disko -- --mode disko --flake ".#${config}"
        nixos-install --root /mnt --flake ".#${config}"
        exit
      fi

    else
      echo "Error: unknown configuration provided"
      exit 1
    fi
done
