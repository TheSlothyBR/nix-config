{ config
, pkgs
, isUser
, lib
, ...
}:{
  options = {
    custom.obsidian = {
      enable = lib.mkEnableOption "Obsidian.md config";
    };
  };

  config = lib.mkIf config.custom.obsidian.enable {
    environment.systemPackages = with pkgs; [
      obsidian
    ];

    environment.persistence."/persist" = {
      users.${isUser} = {
        directories = [
          ".config/obsidian"
        ];
      };
    };
  };
}
