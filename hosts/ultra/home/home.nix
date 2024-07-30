{
  inputs
, globals
, nixpkgs
, ...
}:{
  imports = [
    inputs.home-manager.nixosModules.home-manager
  ];

  programs.home-manager = {
    enable = true;
  };
  
  home-manager = {
    useUserPackages = true;
    useGlobalPkgs = true;
  };

  home = {
    stateVersion = "24.05";
    username = "${globals.ultra.userName}";
    homeDirectory = "/home/${globals.ultra.userName}";
    packages = [
      
    ];
  };
}
