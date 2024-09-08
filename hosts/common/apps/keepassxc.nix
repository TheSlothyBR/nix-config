{ pkgs
, config
}:{
  config == {
    environment.systemPackages = with pkgs; [
      keepassxc
    ];
  };
}
