{ config, pkgs, lib, inputs, ... }:

{
  imports = [
    ../../modules/nixos
    ./hardware-configuration.nix
  ];

  networking.hostName = "nixos-gaming";
  system.stateVersion = "26.05";
}
