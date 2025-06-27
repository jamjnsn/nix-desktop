{
  description = "Nix config for my personal computers.";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";

    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-flatpak.url = "github:gmodena/nix-flatpak";

    vscode-server.url = "github:nix-community/nixos-vscode-server";
  };

   outputs = { self, nixpkgs, home-manager, nix-flatpak, disko, ... }@inputs: 
  let
    hosts = [ "desky" "lappy" ];
    users = [ "jamie" ];

    # TODO: Maybe move this function to a lib?
    mkHost = hostname: {
      name = hostname;

      value = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
         
        modules = [
          # Disk configuration
          disko.nixosModules.disko

          # Declarative Flatpak
          nix-flatpak.nixosModules.nix-flatpak

          # Base configuration
          ./hosts/common
          ./hosts/${hostname}

          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = false;
            home-manager.useUserPackages = true;

            home-manager.users = builtins.listToAttrs (
              map (name: {
                name = name;
                value = import (./users + "/${name}/home.nix");
              }) users
            );

            home-manager.extraSpecialArgs.flake-inputs = inputs;
          }
        ];
      };
    };
  in
  {
    nixosConfigurations = builtins.listToAttrs (map mkHost hosts);
  };
}