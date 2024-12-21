lib: with lib; rec {
  custom = {
    getSetValuesList = globals: paths: exclude: map (name: getAttrFromPath (lists.singleton name ++ paths) globals)(attrNames (filterAttrs(n: v: ! (any (fn: n == fn) exclude)) globals));

    readDirRecursive = dir: mapAttrs
      (file: type: if type == "directory" then custom.readDirRecursive "${dir}/${file}" else type)
      (builtins.readDir dir);

    getFiles = dir: collect isString (mapAttrsRecursive (path: type: concatStringsSep "/" path) (custom.readDirRecursive dir));

    listFiles = dir: map (file: dir + "/${file}") (filter (file: hasSuffix ".nix" file && file != "default.nix" && file != "disko.nix") (custom.getFiles dir));

    ifTheyExist = groups: filter (group: hasAttr group config.users.groups);
  };
}
