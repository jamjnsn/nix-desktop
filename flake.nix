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

    sops-nix.url = "github:Mic92/sops-nix";

    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
  };

  outputs = { self, nixpkgs, home-manager, disko, nix-flatpak, nixos-hardware, ... }@inputs: 
    let
      makeHost = hostName: hostId: nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        
        specialArgs = {
          inherit inputs;
          # This needs to be refactored to support multiple hosts.
          diskDevice = "/dev/disk/by-id/nvme-LENSE30256GMSP34MEAT3TA_1304720404575";
        };

        modules = [
          # Set hostname and ID
          ({ ... }: { networking.hostName = hostName; })
          ({ ... }: { networking.hostId = hostId; })

          # Disk configuration
          disko.nixosModules.disko

          # Declarative Flatpak
          nix-flatpak.nixosModules.nix-flatpak

          # Base configuration
          ./configuration.nix

          # Host-specific configuration
          ./hosts/${hostName}/configuration.nix
          ./hosts/${hostName}/hardware-configuration.nix 

          # Home Manager
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.jamie = import ./users/jamie.nix;
            home-manager.extraSpecialArgs.flake-inputs = inputs;
          }
        ];
      };
    in {
      # Host definitions. Provide a hostname and a unique 32-bit (8 hexadecimal characters) host ID.
      nixosConfigurations = {
        lappy = makeHost "lappy" "3e7b3b0a";
      };
    };
}
