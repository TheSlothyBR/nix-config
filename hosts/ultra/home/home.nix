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
    extraSpecialArgs = { inherit inputs; };
    useUserPackages = true;
    useGlobalPkgs = true;
    users.${globals.ultra.userName} = {
      home = {
        stateVersion = "24.05";
        username = "${globals.ultra.userName}";
        homeDirectory = "/home/${globals.ultra.userName}";
        packages = [
          
        ];
      };
    };
  };
}
