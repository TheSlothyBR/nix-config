{ pkgs
, inputs
, config
, globals
, ...
}:{
  config = {
  services.desktopManager.plasma6.enable = true;

  environment = {
    plasma6.excludePackages = with pkgs.kdePackages; [
      ark
      elisa
      gwenview
      kate
      khelpcenter
      konsole
      okular
      plasma-browser-integration
      print-manager
    ];
  };

  environment.systemPackages = with pkgs.kdePackages; [
    qtstyleplugin-kvantum
    sddm-kcm
  ] ++ [
    #kde-rounded-corners
  ];

  home-manager = {
    sharedModules  = [
      inputs.plasma-manager.homeManagerModules.plasma-manager
    ];
    users.${globals.ultra.userName} = {
      programs.plasma = {
        enable = true;
        overrideConfig = true;
        #resetFilesExclude = [];
        #file = { "file/relative/to/home" = ''explicit settings'' };
        # kwinoutputconfig.json has refresh and resolution info, has to be manualy set
        #configFile = {}; #same pourpose as home-manager options
        #dataFile = {};
      };
    };
  };
};
}
