{ config, pkgs, ... }:

{
  programs.noctalia = {
    enable = true;
    recommendedServices.enable = true;
  };

  home-manager.users.jason = {
    home.packages = with pkgs; [
      awww
    ];
  };
}

