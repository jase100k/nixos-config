{ config, pkgs, ... }:

{
  home-manager.users.jason = {
    home.packages = with pkgs; [
      waypaper
    ];

    xdg.configFile."waypaper/config.ini".text = ''
      [Settings]
      language = en
      backend = none
      folder = ~/Pictures/Wallpaper
      monitors = All
      fill = fill
      sort = name
      post_command = noctalia msg wallpaper-set "$wallpaper"
      number_of_columns = 3
    '';
  };
}
