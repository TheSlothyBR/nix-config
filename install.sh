#!/usr/bin/env bash

configs=(
  ultra
)

while [[ $# -gt 0 ]]; do
  case $1 in
    -h|--help)
      echo "Provide a Nix Flake config name"
      break
      ;;
    -f|--flake)
      FLAKE=$2
      shift # past argument
      shift # past value
      ;;
    *)
      echo "Error: no known argument provided"
      break
      ;;
  esac
done

for config in $configs; do
    if [[ "$config" == "$FLAKE" ]]; then
      nix --extra-experimental-feature 'nix-command flakes' run github:nix-community/disko -- --mode disko --flake "./${config}"
      break
    else
      echo "Error: unknown configuration provided"
      break
    fi
done
