{ pkgs ? import <nixpkgs> {} 
, lib
, flake
, cores ? "0"
, jobs ? "1"
, install ? "1"
}:
let
  installer = pkgs.writeShellScriptBin "installer" ''
    if [[ ${install} -eq 0 ]]; then
      nix --extra-experimental-features 'nix-command flakes' run github:nix-community/disko -- --mode disko --flake ".#${flake}"
    else
      nix --extra-experimental-features 'nix-command flakes' run github:nix-community/disko -- --mode disko --flake ".#${flake}"
      nixos-install --root /mnt --cores ${cores} --max-jobs ${jobs} --flake ".#${flake}"
    fi
  '';
in
pkgs.stdenv.mkDerivation {
  name = "installer";
  src = ./.;
  buildInputs = [ 
    pkgs.git 
    pkgs.sops 
  ] ++ [
    installer
  ];
  SOPS_AGE_KEY = "/tmp/usb/data/secrets/keys.txt";
  buildPhase = ''
    if grep -q "{}" "./hosts/${flake}/system/hardware-configuration.nix"; then
      nixos-generate-config --no-filesystems --root /mnt --show-hardware-config > "./hosts/${flake}/system/hardware-configuration.nix"
    fi
  '';
  installPhase = ''
    mkdir -p $out/bin
    cp ${lib.getBin installer}/bin $out/bin
  '';
}
