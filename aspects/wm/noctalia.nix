{ config, pkgs, ... }:

{
  programs.noctalia = {
    enable = true;
    recommendedServices.enable = true;
    # Wallpaper is rendered natively by Noctalia; no external awww daemon needed.
  };
}