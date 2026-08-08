{ config, pkgs, ... }:

{
  home-manager.users.jason = {
    home.packages = [
      pkgs.opencode
    ];

    xdg.configFile."opencode/tui.json".text = ''
      {
        "$schema": "https://opencode.ai/tui.json",
        "theme": "matugen"
      }
    '';
  };
}
