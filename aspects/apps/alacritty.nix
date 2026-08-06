{ config, pkgs, ... }:

{
  home-manager.users.jason = {
    programs.alacritty = {
      enable = true;
      settings = {
        general = {
          import = [ "~/.config/alacritty/themes/noctalia.toml" ];
        };
        window = {
          padding = {
            x = 12;
            y = 12;
          };
          opacity = 0.88;
          blur = true;
          decorations = "None";
        };
        font = {
          normal = {
            family = "JetBrainsMono Nerd Font";
            style = "Regular";
          };
          bold = {
            family = "JetBrainsMono Nerd Font";
            style = "Bold";
          };
          italic = {
            family = "JetBrainsMono Nerd Font";
            style = "Italic";
          };
          size = 11.0;
        };
        scrolling = {
          history = 10000;
          multiplier = 3;
        };
        keyboard.bindings = [
          { key = "PageUp"; mods = "Shift"; action = "ScrollPageUp"; }
          { key = "PageDown"; mods = "Shift"; action = "ScrollPageDown"; }
          { key = "Up"; mods = "Shift"; action = "ScrollLineUp"; }
          { key = "Down"; mods = "Shift"; action = "ScrollLineDown"; }
          { key = "Home"; mods = "Shift"; action = "ScrollToTop"; }
          { key = "End"; mods = "Shift"; action = "ScrollToBottom"; }
          { key = "Up"; mods = "Control|Shift"; action = "ScrollLineUp"; }
          { key = "Down"; mods = "Control|Shift"; action = "ScrollLineDown"; }
          { key = "PageUp"; mods = "Control|Shift"; action = "ScrollPageUp"; }
          { key = "PageDown"; mods = "Control|Shift"; action = "ScrollPageDown"; }
        ];
      };
    };

    xdg.configFile."alacritty/alacritty.toml".force = true;
  };
}
