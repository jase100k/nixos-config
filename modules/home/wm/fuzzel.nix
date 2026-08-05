{ pkgs, ... }:

{
  programs.fuzzel = {
    enable = true;
    settings = {
      main = {
        include = "~/.config/fuzzel/themes/noctalia";
        font = "JetBrainsMono Nerd Font:size=12";
        terminal = "${pkgs.alacritty}/bin/alacritty";
        prompt = "'❯ '";
        icon-theme = "Papirus-Dark";
        fields = "filename,name,generic,exec,categories,keywords";
        lines = 12;
        width = 45;
        horizontal-pad = 20;
        vertical-pad = 14;
        inner-pad = 8;
        line-height = 24;
      };
      border = {
        width = 2;
        radius = 12;
      };
    };
  };
}
