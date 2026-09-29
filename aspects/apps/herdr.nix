{ config, pkgs, ... }:

{
  home-manager.users.jason = {
    home.packages = with pkgs; [
      herdr
    ];
  };
}
