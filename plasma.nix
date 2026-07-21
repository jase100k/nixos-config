{ pkgs, ... }:

{
  programs.plasma = {
    enable = true;
    overrideConfig = false;

    workspace = {
      clickItemTo = "open";
      colorScheme = "CatppuccinMocha";
      theme = "breeze-dark";
      iconTheme = "Papirus-Dark";
      cursor = {
        theme = "Bibata-Modern-Classic";
        size = 24;
      };
      wallpaper = "${pkgs.kdePackages.plasma-workspace-wallpapers}/share/wallpapers/Next/contents/images/2560x1440.png";
    };

    kwin = {
      effects = {
        blur = {
          enable = true;
          strength = 12;
        };
        dimInactive.enable = true;
        translucency.enable = true;
        snapHelper.enable = true;
        minimization.animation = "magiclamp";
        desktopSwitching.animation = "slide";
        windowOpenClose.animation = "fade";
      };
      borderlessMaximizedWindows = true;
      virtualDesktops = {
        number = 3;
        rows = 1;
      };
      titlebarButtons = {
        right = [ "minimize" "maximize" "close" ];
      };
    };

    fonts = {
      general = {
        family = "IBM Plex Sans";
        pointSize = 10;
      };
      fixedWidth = {
        family = "JetBrains Mono";
        pointSize = 11;
      };
      small = {
        family = "IBM Plex Sans";
        pointSize = 8;
      };
      toolbar = {
        family = "IBM Plex Sans";
        pointSize = 10;
      };
      menu = {
        family = "IBM Plex Sans";
        pointSize = 10;
      };
      windowTitle = {
        family = "IBM Plex Sans";
        pointSize = 10;
        weight = 63;
      };
    };

    shortcuts = {
      kwin = {
        "Overview" = "Meta+W";
        "ShowDesktop" = "Meta+D";
        "WindowClose" = "Alt+F4";
        "MaximizeWindow" = "Meta+Up";
        "MinimizeWindow" = "Meta+Down";
      };
    };
  };

  programs.konsole = {
    enable = true;
    defaultProfile = "default";
    profiles.default = {
      name = "Catppuccin Mocha";
      font = {
        name = "JetBrains Mono";
        size = 12;
      };
      colorScheme = "Catppuccin-Mocha";
      extraConfig = {
        "General" = {
          "Blur" = true;
          "Opacity" = 0.9;
        };
      };
    };
  };

  home.packages = with pkgs; [
    qt6Packages.qtstyleplugin-kvantum

    papirus-icon-theme
    bibata-cursors

    jetbrains-mono
    ibm-plex
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-color-emoji

    catppuccin-kde

    kdePackages.dolphin
    kdePackages.kate
    kdePackages.spectacle
    kdePackages.kcalc
    kdePackages.gwenview
    kdePackages.ark
    kdePackages.discover
    kdePackages.filelight
    kdePackages.kdeconnect-kde
    kdePackages.konsole

    wl-clipboard
    wayland-utils
  ];

  xdg.configFile."Kvantum/kvantum.kvconfig".text = ''
    [General]
    theme=CatppuccinMocha
  '';

  gtk = {
    enable = true;
    theme = {
      name = "Catppuccin-Mocha-Standard-Blue-Dark";
      package = pkgs.catppuccin-gtk.override {
        accents = [ "blue" ];
        size = "standard";
        tweaks = [ "normal" ];
      };
    };
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };
  };

  qt = {
    enable = true;
    platformTheme.name = "qtct";
    style = {
      name = "kvantum";
    };
  };

  programs.alacritty = {
    enable = true;
    settings = {
      window = {
        padding = {
          x = 12;
          y = 12;
        };
        opacity = 0.92;
        blur = true;
        decorations = "None";
        corner_radius = 12;
      };
      font = {
        family = "JetBrains Mono";
        size = 12.0;
      };
      colors = {
        primary = {
          background = "#1e1e2e";
          foreground = "#cdd6f4";
          dim_foreground = "#7f849c";
          bright_foreground = "#cdd6f4";
        };
        cursor = {
          text = "#1e1e2e";
          cursor = "#f5e0dc";
        };
        vi_mode_cursor = {
          text = "#1e1e2e";
          cursor = "#f5e0dc";
        };
        search = {
          matches = {
            foreground = "#1e1e2e";
            background = "#a6adc8";
          };
          focused_match = {
            foreground = "#1e1e2e";
            background = "#a6e3a1";
          };
        };
        normal = {
          black = "#45475a";
          red = "#f38ba8";
          green = "#a6e3a1";
          yellow = "#f9e2af";
          blue = "#89b4fa";
          magenta = "#f5c2e7";
          cyan = "#94e2d5";
          white = "#bac2de";
        };
        bright = {
          black = "#585b70";
          red = "#f38ba8";
          green = "#a6e3a1";
          yellow = "#f9e2af";
          blue = "#89b4fa";
          magenta = "#f5c2e7";
          cyan = "#94e2d5";
          white = "#a6adc8";
        };
        dim = {
          black = "#45475a";
          red = "#f38ba8";
          green = "#a6e3a1";
          yellow = "#f9e2af";
          blue = "#89b4fa";
          magenta = "#f5c2e7";
          cyan = "#94e2d5";
          white = "#bac2de";
        };
      };
    };
  };
}
