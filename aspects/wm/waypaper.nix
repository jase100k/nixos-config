{ config, pkgs, ... }:

{
  home-manager.users.jason = {
    home.packages = with pkgs; [
      waypaper
      awww
    ];

    home.activation.configureWaypaper = config.home-manager.users.jason.lib.dag.entryAfter [ "writeBoundary" ] ''
      mkdir -p $HOME/.config/waypaper
      rm -f $HOME/.config/waypaper/config.ini
      cat <<'EOF' > $HOME/.config/waypaper/config.ini
[Settings]
language = en
backend = awww
folder = ~/Pictures/Wallpaper
monitors = All
fill = fill
sort = name
post_command = noctalia msg wallpaper-set "$wallpaper"
number_of_columns = 3
EOF
      chmod 644 $HOME/.config/waypaper/config.ini
    '';
  };
}


