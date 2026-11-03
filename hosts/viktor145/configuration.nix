{ lib, pkgs, ... }:
{
  imports = [ ./hardware-configuration.nix ];

  networking.hostName = "viktor145";

  services.openssh = {
    enable = true;
    startWhenNeeded = false;
    settings = {
      PermitRootLogin = "prohibit-password";
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
    };
  };
  users.mutableUsers = false;
  users.users.root = {
    initialHashedPassword = lib.mkForce null;
    hashedPassword = "!";
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMGgvYnVaOzJMe0UffhFSxIZpsF4a7SgqRJInAeQ+7TH szymon@szymon"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIERXPC9InOx065o996AuaxIWOifoEdQBlZn/D8pJ+GHQ shyman@notwobug"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIM9uxaQyMRsQMEKle3YP+g8Un5V6OCQY63ABIllckYUn shyman@threenkpad"
    ];
  };

  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    max-jobs = 1;
    cores = 1;
  };

  # Leave the large NixOS manual out of this small VPS.
  documentation.enable = false;
  documentation.nixos.enable = false;
  environment.systemPackages = with pkgs; [
    iproute2
    procps
    screen
    vis
  ];

  # Keep this value when upgrading NixOS.
  system.stateVersion = "26.05";
}
