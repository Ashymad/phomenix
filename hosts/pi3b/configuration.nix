{ pkgs, ... }:
{
  imports =
    [
      ./hardware-configuration.nix
    ];

  boot.loader.grub.enable = false;
  boot.loader.generic-extlinux-compatible.enable = true;

  networking.hostName = "pi3b";

  networking.interfaces.enu1u1.ipv4.addresses = [
    {
	    address = "192.168.1.3";
	    prefixLength = 24;
    }
  ];

  networking.defaultGateway = "192.168.1.1";
  networking.nameservers = [ "192.168.1.3" ];

  time.timeZone = "Europe/Warsaw";

  nix.settings = {
    max-jobs = 1;
    cores = 1;
  };

  containers.technitium = {
    autoStart = true;
    config = { pkgs, ... }:
      {
	      services.technitium-dns-server.enable = true;
	      system.stateVersion = "26.11";
      };
  };

  zramSwap.enable = true;

  services.openssh.enable = true;

  networking.firewall.enable = false;

  system.stateVersion = "26.11"; # Never change this
}

