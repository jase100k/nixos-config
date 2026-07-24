{ ... }:

{
  xdg.configFile."noctalia/config.toml".text = ''
    [theme]
    mode = "dark"
    source = "builtin"
    builtin = "Ayu"

    [theme.templates]
    enable_community_templates = true
    community_ids = ["steam", "pywalfox-beta4", "neovim"]

    [shell]
    niri_overview_type_to_launch_enabled = true

    [[control_center.shortcuts]]
    type = "wifi"
    [[control_center.shortcuts]]
    type = "bluetooth"
    [[control_center.shortcuts]]
    type = "nightlight"
    [[control_center.shortcuts]]
    type = "caffeine"
    [[control_center.shortcuts]]
    type = "wallpaper"
    [[control_center.shortcuts]]
    type = "session"

    [wallpaper]
    enabled = true
    fill_mode = "crop"
    transition_on_startup = false

    [backdrop]
    enabled = false
  '';
}
