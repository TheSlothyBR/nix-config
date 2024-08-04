#!/usr/bin/env bash

configs=(
  ultra
)

NO_INSTALL=1

if [[ $# -eq 0 ]]; then
  echo "Provide a Nix Flake config name"
  exit
fi

while [[ $# -gt 0 ]]; do
  case $1 in
    -h|--help)
      echo "Provide a Nix Flake config name"
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
    *)
      echo "Error: no known argument provided"
      exit 1
      ;;
  esac
done

for config in $configs; do
    if [[ "$config" == "$FLAKE" ]]; then
      if [[ NO_INSTALL -eq 0 ]]; then
        nix --extra-experimental-features 'nix-command flakes' run github:nix-community/disko -- --mode disko --flake ".#${config}"
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
