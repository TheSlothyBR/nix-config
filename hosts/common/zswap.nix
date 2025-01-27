{
  config,
  lib,
  pkgs,
  ...
}:
{
  options = {
    custom.zswap = {
      enable = lib.mkEnableOption "zSwap config";
    };
  };

  config = lib.mkIf config.custom.zswap.enable {
    systemd.services.zswap = {
      description = "Enable zSwap";
      enable = true;
      wantedBy = [ "basic.target" ];
      path = [ pkgs.bash ];
      serviceConfig = {
        ExecStart = ''
          ${pkgs.bash}/bin/bash -c 'cd /sys/module/zswap/parameters && \
                  echo 1 > enabled && \
                  echo 25 > max_pool_percent && \
                  echo zstd > compressor && \
                  echo z3fold > zpool'
        '';
        Type = "simple";
      };
    };
  };
}
