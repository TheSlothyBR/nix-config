{ lib
, ...
}:{
  imports = [#lib.custom.listFiles ./.;
    ./disko.nix
    ./hardware-configuration.nix
    ./home.nix
    ./impermanence.nix
    ./networking.nix
    ./security.nix
  ];
}
