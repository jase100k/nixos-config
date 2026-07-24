{ ... }:

{
  xdg.configFile."noctalia/config.toml".text = ''
    [theme]
    mode = "dark"
    source = "builtin"
    builtin = "Catppuccin"

    [wallpaper]
    enabled = true
    fill_mode = "crop"
    transition_on_startup = false

    [backdrop]
    enabled = true
    blur_intensity = 0.5
    tint_intensity = 0.3
  '';
}
