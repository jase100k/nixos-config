{ config, pkgs, ... }:

{
  programs.noctalia = {
    enable = true;
    recommendedServices.enable = true;
  };
}


