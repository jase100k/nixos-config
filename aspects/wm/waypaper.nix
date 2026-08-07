{ config, pkgs, ... }:

{
  home-manager.users.jason = {
    home.packages = with pkgs; [
      waypaper
      awww
    ];

    xdg.configFile."waypaper/config.ini".text = ''
      [Settings]
      language = en
      backend = awww
      folder = ~/Pictures/Wallpaper
      monitors = All
      fill = fill
      sort = name
      post_command = noctalia msg wallpaper-set "$wallpaper" && noctalia-sync-theme
      number_of_columns = 3
    '';
  };
}

