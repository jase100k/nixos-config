{ config, pkgs, inputs, ... }:

{
  # Torlink - sleek terminal torrent finder and downloader
  environment.systemPackages = [
    inputs.torlink.packages.${pkgs.system}.default
  ];
}
