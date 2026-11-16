{
  description = "NixOS HomeLab";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    chaotic = {
      url = "github:chaotic-cx/nyx/nyxpkgs-unstable";
      inputs.home-manager.follows = "home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    ssh-keys = {
      url = "sourcehut:~ashymad/keys";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    dotfiles = {
      url = "sourcehut:~ashymad/dotfiles";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ nixpkgs, chaotic, home-manager, ssh-keys, dotfiles, ... }:
    let
      inherit (chaotic.vendored) jovian;
    in
    {
      nixosConfigurations = {
        pi3b = nixpkgs.lib.nixosSystem {
          system = "aarch64-linux";
          specialArgs = {
            inherit inputs;
          };
          modules = [
            ./hosts/pi3b/configuration.nix
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
            }
            ./users/shyman.nix
          ];
        };
        viktor145 = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = {
            inherit inputs;
          };
          modules = [
            (import ./overlays/lix.nix)
            ./hosts/viktor145/configuration.nix
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
            }
            ./users/shyman.nix
          ];
        };
        fourager = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = {
            inherit inputs;
          };
          modules = [
            (import ./overlays/lix.nix)
            ./hosts/fourager/configuration.nix
            jovian.nixosModules.default
            chaotic.nixosModules.default
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
            }
            ./users/shyman.nix
          ];
        };
      };
    };
}
