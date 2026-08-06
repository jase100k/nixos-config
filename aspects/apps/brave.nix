{ config, pkgs, ... }:

{
  home-manager.users.jason = {
    home.packages = [ pkgs.brave ];
  };
}
