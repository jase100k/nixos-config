{ config, pkgs, inputs, ... }:

{
  imports = [
    inputs.stylix.nixosModules.stylix
  ];

  stylix = {
    enable = true;
    autoEnable = true; # Automatically theme all present and future supported apps
    polarity = "dark";
    base16Scheme = if builtins.pathExists "/home/jason/.config/noctalia/stylix-scheme.yaml"
      then "/home/jason/.config/noctalia/stylix-scheme.yaml"
      else "${pkgs.base16-schemes}/share/themes/tokyo-night-dark.yaml";
    image = ../../assets/wallpaper.jpg;



    fonts = {
      monospace = {
        package = pkgs.jetbrains-mono;
        name = "JetBrains Mono";
      };
      sansSerif = {
        package = pkgs.noto-fonts;
        name = "Noto Sans";
      };
      emoji = {
        package = pkgs.noto-fonts-color-emoji;
        name = "Noto Color Emoji";
      };
    };

    cursor = {
      package = pkgs.bibata-cursors;
      name = "Bibata-Modern-Classic";
      size = 24;
    };
  };

  home-manager.users.jason = {
    xdg.configFile."gtk-3.0/gtk.css".force = true;
    xdg.configFile."gtk-4.0/gtk.css".force = true;
  };
}

