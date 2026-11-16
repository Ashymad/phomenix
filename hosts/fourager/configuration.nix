# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./fan2go-configuration.nix
    ];

  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };

    kernelPackages = pkgs.linuxPackages_cachyos;
    binfmt.emulatedSystems = [ "aarch64-linux" ];
    kernelModules = [ "nct6775" ];
  };

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
    trusted-users = [ "@wheel" ];
  };

  services = {
    pipewire = {
      enable = true;
      pulse.enable = true;
    };

    openssh = {
      enable = true;
    };
  };

  environment.systemPackages = with pkgs; [
    iproute2
    procps
    screen
    lm_sensors
    fan2go
    nvi
    gitMinimal
    mlterm-wayland
  ];

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  hardware.amdgpu.initrd.enable = true;

  system.stateVersion = "25.11"; # Did you read the comment?
}

