# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "fourager";

  time.timeZone = "Europe/Warsaw";

  networking.useNetworkd = true;

  systemd.network = {
    enable = true;
    networks."50-enp5s0" = {
      matchConfig.Name = "enp5s0";
      networkConfig.DHCP = "yes";
      linkConfig.RequiredForOnline = "yes";
    };
  };

  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
  };

  services.pipewire = {
    enable = true;
    pulse.enable = true;
  };

  services.openssh = {
    enable = true;
  };

  environment.systemPackages = with pkgs; [
    iproute2
    procps
    screen
    nvi
    gitMinimal
  ];

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  hardware.amdgpu.initrd.enable = true;

  system.stateVersion = "25.11"; # Did you read the comment?
}

