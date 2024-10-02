{ inputs
, pkgs
, globals
, ...
}:{
  environment.systemPackages = with pkgs; [
    obsidian
  ];

  environment.persistence."/persist" = {
    users.${globals.ultra.userName} = {
      directories = [
        ".config/obsidian"
      ];
    };
  };
}
