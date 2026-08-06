{ config, pkgs, lib, ... }:

{
  services.xserver = {
    enable = true;
    xkb.layout = "us";
    exportConfiguration = true;
  };

  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
    theme = "sddm-astronaut";
  };

  environment.systemPackages = [
    pkgs.sddm-astronaut
  ];

  services.displayManager.sessionPackages = [ pkgs.niri ];
  services.displayManager.defaultSession = lib.mkForce null;
}
