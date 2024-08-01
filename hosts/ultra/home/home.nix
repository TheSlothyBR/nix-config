{
  inputs
, globals
, nixpkgs
, ...
}:{
  imports = [
    inputs.home-manager.nixosModules.home-manager
  ];

  home-manager = {
    extraSpecialArgs = { inherit inputs; };
    useUserPackages = true;
    useGlobalPkgs = true;
    users.${globals.ultra.userName} = {
      programs.home-manager.enable = true;
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
