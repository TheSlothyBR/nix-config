{ config
, lib
, ...
}:{
  options = {
    custom.battery-optimisation = {
      enable = lib.mkEnableOption "Battery life optimization";
    };
  };

  config = lib.mkIf config.custom.battery-optimisation.enable {
    services = {
      system76-scheduler.settings.cfsProfiles.enable = true;

      tlp = {
        enable = true;
        settings = {
          CPU_BOOST_ON_AC = 1;
          CPU_BOOST_ON_BAT = 0;
          CPU_HWP_DYN_BOOST_ON_AC = 1;
          CPU_HWP_DYN_BOOST_ON_BAT = 0;
          CPU_SCALING_GOVERNOR_ON_AC = "performance";
          CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
          DEVICES_TO_DISABLE_ON_STARTUP = "bluetooth nfc wifi wwan";
          PLATFORM_PROFILE_ON_AC = "performance";
          PLATFORM_PROFILE_ON_BAT = "low-power";
          CPU_ENERGY_PERF_POLICY_ON_AC = "performance";
          CPU_ENERGY_PERF_POLICY_ON_BAT = "power";
          TLP_DEFAULT_MODE = "BAT";
          TLP_PERSISTENT_DEFAULT = 0;
        };
      };

      thermald.enable = true;

      power-profiles-daemon.enable = false;
    };

    powerManagement.powertop.enable = true;
  };
}
