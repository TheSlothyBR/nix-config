{ pkgs
, config
, ...
}:{
  config = {
    environment.systemPackages = with pkgs; [
      obsidian
    ];
  };
}
