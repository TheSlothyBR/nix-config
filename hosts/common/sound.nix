{ config
, lib
, ...
}:{
  options = {
    custom.sound = {
      enable = lib.mkEnableOption "Pulse Audio config";
      jack.enable = lib.mkEnableOption "JACK emulation";
    };
  };

  config = lib.mkIf config.custom.sound.enable {
    security.rtkit.enable = true;
    services.pipewire = {
      enable = true;
      audio.enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = config.custom.sound.jack.enable;
    };
  };
}
