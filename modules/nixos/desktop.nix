{ config, pkgs, lib, inputs, ... }:

{
  # X11 / Display Server
  services.xserver = {
    enable = true;
    xkb.layout = "us";
    exportConfiguration = true;
  };

  # SDDM Display Manager & Session Packages
  services.displayManager.sddm.enable = true;
  services.displayManager.sessionPackages = [ inputs.niri.packages.x86_64-linux.niri-stable ];
  services.desktopManager.plasma6.enable = true;

  # MangoWM - Wayland compositor (available as SDDM session)
  programs.mango = {
    enable = true;
    addLoginEntry = true;
  };

  # Noctalia v5 - Desktop shell for MangoWM and Niri
  programs.noctalia = {
    enable = true;
    recommendedServices.enable = true;
  };

  # Override plasma6's mkDefault so SDDM shows session selector
  services.displayManager.defaultSession = lib.mkForce null;

  # Flatpak
  services.flatpak.enable = true;

  # XDG Portals
  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
    config.common.default = [ "gtk" ];
  };
}
