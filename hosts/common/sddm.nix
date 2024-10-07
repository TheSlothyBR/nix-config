{
  services.displayManager = {
    sddm = {
      enable = true;
      wayland = {
        enable = true;
        compositor = "kwin";
      };
      autoNumlock = true;
      theme = "breeze";
    };
    defaultSession = "plasma";
  };
}
