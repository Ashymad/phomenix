{ inputs, config, lib, pkgs, ... }:
{
  imports = [ ./hardware-configuration.nix ];

  networking.hostName = "viktor145";

  services.openssh = {
    enable = true;
    startWhenNeeded = false;
    settings = {
      PermitRootLogin = "no";
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
    };
  };

  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    max-jobs = 2;
    cores = 4;
  };

  environment.systemPackages = with pkgs; [
    iproute2
    procps
    screen
    vis
    git
  ];

  # Keep this value when upgrading NixOS.
  system.stateVersion = "26.05";
}
