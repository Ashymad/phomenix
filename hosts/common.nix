{ inputs, config, lib, pkgs, ... }:
{
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
  };

  nix.nixPath = [ "nixpkgs=${inputs.nixpkgs}" ];

  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    trusted-users = [ "@wheel" ];
  };

  environment.systemPackages = with pkgs; [
    iproute2
    procps
    screen
    nvi
    gitMinimal
  ];
}
