{ config, pkgs, ... }:

{
  environment.systemPackages = [ pkgs.fastfetch ];
}
