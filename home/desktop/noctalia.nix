{ ... }:

{
  xdg.configFile."noctalia/config.toml".text = ''
    [theme]
    mode = "dark"
    source = "builtin"
    builtin = "Catppuccin"

    [theme.templates]
    enable_community_templates = true
    community_ids = ["steam"]

    [wallpaper]
    enabled = true
    fill_mode = "crop"
    transition_on_startup = false

    [backdrop]
    enabled = false
  '';
}
