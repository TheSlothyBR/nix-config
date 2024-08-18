{ pkgs ? import <nixpkgs> {}
, lib
, flake
, cores ? "0"
, jobs ? "1"
, install ? true
}:
let
  installer = pkgs.writeShellScriptBin "installer" ''
    export SOPS_AGE_KEY_FILE="/persist/home/.config/sops/age/keys.txt"
    if [[ "${install}" == "false" ]]; then
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
  buildPhase = ''
    if grep -q "{}" "./hosts/${flake}/system/hardware-configuration.nix"; then
      nixos-generate-config --no-filesystems --root /mnt --show-hardware-config > "./hosts/${flake}/system/hardware-configuration.nix"
    fi
  '';
  installPhase = ''
    mkdir -p $out
    cp -r $src $out
    cp ${lib.getBin installer}/bin $out
  '';
}
