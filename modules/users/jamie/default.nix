{
  config,
  pkgs,
  lib,
  inputs,
  ...
}:
{
  imports = [
    inputs.nix-flatpak.homeManagerModules.nix-flatpak
    ../../home
  ];

  # Add .local/bin to PATH
  home.sessionVariables = {
    PATH = "$HOME/.local/bin:$PATH";
  };

  # Add scripts folder
  home.file.".local/bin" = {
    source = ./scripts;
    recursive = true;
    executable = true;
  };
}
