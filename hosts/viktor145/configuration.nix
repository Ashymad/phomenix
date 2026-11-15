{ inputs, config, lib, pkgs, ... }:
{
  imports = [ ./hardware-configuration.nix ];

  networking.hostName = "viktor145";

  systemd.services.nix-daemon.serviceConfig = {
    MemoryHigh = "700M";
    MemoryMax = "900M";
  };

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
    max-jobs = 1;
    cores = 1;
    trusted-users = [ "@wheel" ];
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
