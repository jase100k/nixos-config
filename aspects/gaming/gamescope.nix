{ config, pkgs, ... }:

{
  programs.gamescope = {
    enable = true;
    capSysNice = true;
  };

  home-manager.users.jason = {
    xdg.configFile."gamescope/gamescope.env" = {
      text = ''
        MANGOHUD=1
      '';
    };
  };
}
