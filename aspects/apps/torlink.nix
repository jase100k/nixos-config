{ config, pkgs, inputs, ... }:

let
  torlinkPkg = inputs.torlink.packages.${pkgs.stdenv.hostPlatform.system}.default;

  # Create 'torlink' command alias pointing to 'torlnk' binary
  torlinkBin = pkgs.writeShellScriptBin "torlink" ''
    exec ${torlinkPkg}/bin/torlnk "$@"
  '';

  # Desktop launcher entry to open Torlink in Alacritty terminal
  torlinkDesktop = pkgs.makeDesktopItem {
    name = "torlink";
    desktopName = "Torlink";
    genericName = "Torrent Finder & Downloader";
    exec = "${pkgs.alacritty}/bin/alacritty -e ${torlinkPkg}/bin/torlnk";
    icon = "utilities-terminal";
    categories = [ "Network" "ConsoleOnly" "Utility" ];
    terminal = false;
  };
in
{
  # Torlink - sleek terminal torrent finder and downloader
  environment.systemPackages = [
    torlinkPkg
    torlinkBin
    torlinkDesktop
  ];
}

