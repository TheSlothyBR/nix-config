{ lib
, ...
}:{
  #imports = with builtins;
  #  map (fn: ./${fn})
  #    (filter (fn: fn != "defaut.nix") (attrNames (readDir ./.)));
  imports = lib.custom.listFiles ./.;
}
