{ pkgs, ... }:

{
  programs.kitty = {
    enable = true;
    themeFile = "Catppuccin-Mocha";
    font = {
      name = "JetBrainsMono Nerd Font";
      size = 11;
    };
    settings = {
      confirm_os_window_close = 0;
      enable_audio_bell = false;
      background_opacity = "0.88";
      window_padding_width = 12;
      cursor_shape = "beam";
      cursor_blink_interval = 0.5;
      hide_window_decorations = "yes";
    };
  };
}
