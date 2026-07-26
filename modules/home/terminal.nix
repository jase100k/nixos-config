{ pkgs, ... }:

{
  # Kitty Terminal Configuration (allow Noctalia dynamic theme templates)
  programs.kitty = {
    enable = true;
    font = {
      name = "JetBrainsMono Nerd Font";
      size = 11;
    };
    settings = {
      confirm_os_window_close = 0;
      enable_audio_bell = false;
      background_opacity = "0.88";
      hide_window_decorations = "yes";
    };
    extraConfig = ''
      include noctalia-theme.conf
    '';
  };

  # Alacritty Terminal Configuration (allow Noctalia dynamic theme templates)
  programs.alacritty = {
    enable = true;
    settings = {
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
    };
  };

  xdg.configFile."alacritty/alacritty.toml".force = true;
}
