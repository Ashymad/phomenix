{ inputs, config, lib, pkgs, ... }:
let
  inherit (inputs) nixpkgs;
in
{
  nixpkgs.config.allowUnfreePredicate = pkgs:
    builtins.elem (lib.getName pkgs) [
      "steamdeck-hw-theme"
      "steam-jupiter-unwrapped"
      "steam"
    ]; 

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

  time.timeZone = "Europe/Warsaw";

  networking = {
    networkmanager.enable = true;
    hostName = "fourager";
    defaultGateway = "192.168.1.1";
    nameservers = [ "192.168.1.3" ];
    interfaces.enp5s0.ipv4.addresses = [
      {
	      address = "192.168.1.4";
	      prefixLength = 24;
      }
    ];
  };

  services = {
    pipewire = {
      enable = true;
      pulse.enable = true;
    };

    openssh = {
      enable = true;
    };

    sunshine = {
      enable = true;
      autoStart = true;  # optional: starts Sunshine automatically on login
      capSysAdmin = true;
      openFirewall = true;
    };

  };

  hardware = {
    graphics = {
      enable = true;
      enable32Bit = true;
    };

    amdgpu.initrd.enable = true;
  };

  users.users.player = {
    isNormalUser = true;
    extraGroups = [ "uinput" ]; # Enable ‘sudo’ for the user.
  };

  jovian = {
    hardware.has.amd.gpu = true;
    steam = {
      desktopSession = "gamescope-wayland";
      enable = true;
      autoStart = true;
      user = "player";
    };
  };

  programs.steam.enable = true;

  system.stateVersion = "25.11"; # Did you read the comment?
}
