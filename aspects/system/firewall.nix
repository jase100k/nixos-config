{ config, pkgs, ... }:

{
  networking.firewall = {
    enable = true;
    allowPing = true;
    allowedTCPPorts = [ 8000 ];
  };
}
