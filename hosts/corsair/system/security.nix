{ config
, pkgs
, ...
}:{
  users.users.root = {
    hashedPassword = "!";
    shell = "${pkgs.shadow}/bin/nologin";
  };

  security = {
    sudo = {
      extraConfig = ''
        Defaults lecture="never"  
      '';
    };
  };
}
