# Provider-specific configuration for this unprivileged Mikrus LXC container.
{ modulesPath, ... }:
{
  imports = [ (modulesPath + "/virtualisation/lxc-container.nix") ];

  networking.useDHCP = false;
  networking.useNetworkd = true;
  networking.useHostResolvConf = false;
  networking.nameservers = [ "185.12.64.2" "2a01:4ff:ff00::add:1" "185.12.64.1" ];
  systemd.network.networks."10-eth0" = {
    matchConfig.Name = "eth0";
    address = [ "192.168.1.145/24" "2a01:4f9:6a:1060::145/128" ];
    networkConfig = { DHCP = "no"; IPv6AcceptRA = false; };
    routes = [
      { Destination = "0.0.0.0/0"; Gateway = "192.168.1.1"; }
      { Destination = "2a01:4f9:6a:1060::2/128"; }
      { Destination = "::/0"; Gateway = "2a01:4f9:6a:1060::2"; GatewayOnLink = true; }
    ];
  };

  # Prevent Proxmox startup hooks from replacing NixOS-managed files.
  environment.etc = {
    ".pve-ignore.hosts".text = "";
    ".pve-ignore.hostname".text = "";
    ".pve-ignore.resolv.conf".text = "";
    "systemd/network/.pve-ignore.eth0.network".text = "";
  };
  systemd.mounts = [ { where = "/sys/kernel/debug"; enable = false; } ];

  # Keep build-user IDs within the container's mapped UID/GID range.
  nix.settings.experimental-features = [ "auto-allocate-uids" ];
  nix.settings.auto-allocate-uids = false;

  # Retain all existing SSH host-key types, including the original ECDSA key.
  services.openssh.hostKeys = [
    { type = "rsa"; path = "/etc/ssh/ssh_host_rsa_key"; }
    { type = "ecdsa"; path = "/etc/ssh/ssh_host_ecdsa_key"; }
    { type = "ed25519"; path = "/etc/ssh/ssh_host_ed25519_key"; }
  ];

  # The LXC image module imports installer helpers; this is an installed system.
  system.installer.channel.enable = false;
  installer.cloneConfig = false;
}
