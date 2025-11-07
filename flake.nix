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

    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    agenix.url = "github:ryantm/agenix";

    neuwaita = {
      url = "github:RusticBard/Neuwaita";
      flake = false;
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      nix-flatpak,
      disko,
      agenix,
      nixos-hardware,
      ...
    }@inputs:
    let
      pkgs = import nixpkgs {
        config.allowUnfree = true;
      };

      # Define hosts
      hosts = [
        {
          name = "desky";
          id = "3e7b3b0b";
          rootDisk = "/dev/disk/by-id/nvme-CT2000P3SSD8_2311E6BBF76F";
          bridgeInterfaces = [ "enp42s0" ];
        }
        {
          name = "lappy";
          id = "3e7b3b0a";
          rootDisk = "/dev/disk/by-id/nvme-WD_BLACK_SN770_1TB_22253F800572";
          bridgeInterfaces = [ "enp5s0" ];
        }
      ];

      mkHost = host: {
        name = host.name;

        value = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";

          modules = [

            ./hosts/${host.name}
          ];

          specialArgs = {
            inherit self inputs host;
          };
        };
      };
    in
    {
      nixosConfigurations = builtins.listToAttrs (map mkHost hosts);
    };
}
