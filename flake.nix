{
  description = "Nix config for my personal computers.";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";

    home-manager.url = "github:nix-community/home-manager/release-25.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs";

    nix-flatpak.url = "github:gmodena/nix-flatpak";
    vscode-server.url = "github:nix-community/nixos-vscode-server";

    nur.url = "github:nix-community/NUR";
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      nix-flatpak,
      disko,
      ...
    }@inputs:
    let
      pkgs = import nixpkgs {
        config.allowUnfree = true;
      };

      # Define hosts and users
      hosts = [
        "desky"
        "lappy"
      ];

      mkHost = hostname: {
        name = hostname;

        value = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";

          modules = [
            ./hosts/${hostname}
          ];

          specialArgs = {
            inherit self inputs;
          };
        };
      };
    in
    {
      nixosConfigurations = builtins.listToAttrs (map mkHost hosts);
    };
}
