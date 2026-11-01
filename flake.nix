{
  description = "NixOS HomeLab";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ nixpkgs, home-manager, ... }:
    let
      pkgs = nixpkgs.legacyPackages.aarch64-linux;
    in
      {
        nixosConfigurations = {
          pi3b = nixpkgs.lib.nixosSystem {
            system = "aarch64-linux";
            modules = [
              ./configuration.nix
              home-manager.nixosModules.home-manager
              {
                home-manager.useGlobalPkgs = true;
                home-manager.useUserPackages = true;
                home-manager.extraSpecialArgs = { inherit pkgs; };
                home-manager.users.shyman = ./shyman.nix;
              }
            ];
          };
        };
      };
}
