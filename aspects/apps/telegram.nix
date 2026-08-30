{ config, pkgs, ... }:

{
  # Telegram Messaging Clients
  environment.systemPackages = with pkgs; [
    materialgram
    nchat
  ];
}
