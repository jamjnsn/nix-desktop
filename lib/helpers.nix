{ lib, ... }:
{
  importDir =
    dir:
    let
      files = builtins.readDir dir;

      # Get .nix files in the current directory
      nixFiles = lib.filterAttrs (name: type: type == "regular" && lib.hasSuffix ".nix" name) files;

      # Get subdirectories
      directories = lib.filterAttrs (name: type: type == "directory") files;

      # Paths to .nix files
      nixPaths = lib.mapAttrsToList (name: _: dir + "/${name}") nixFiles;

      # Paths to default.nix in subdirectories (if they exist)
      defaultPaths = lib.mapAttrsToList (
        name: _:
        let
          defaultNix = dir + "/${name}/default.nix";
        in
        if builtins.pathExists defaultNix then defaultNix else null
      ) directories;

      # Filter out null values
      validDefaultPaths = builtins.filter (path: path != null) defaultPaths;
    in
    nixPaths ++ validDefaultPaths;
}
