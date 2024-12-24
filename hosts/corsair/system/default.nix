{ lib
, ...
}:{
  imports = lib.custom.listFiles ./.;
}
