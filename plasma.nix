{ pkgs, ... }:

{
  programs.plasma = {
    enable = true;

    workspace = {
      clickItemTo = "open";
      tooltipDelay = 1;
      colorScheme = "CatppuccinMocha";
      theme = "breeze-dark";
      iconTheme = "Papirus-Dark";
      cursor = {
        theme = "Bibata-Modern-Classic";
        size = 24;
      };
      windowDecorations = {
        library = "org.kde.breeze";
        theme = "Breeze";
      };
      widgetStyle = "Breeze";
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
        wobblyWindows.enable = false;
        desktopSwitching = {
          animation = "slide";
        };
        windowOpenClose = {
          animation = "fade";
        };
      };
      borderlessMaximizedWindows = true;
      virtualDesktops = {
        number = 3;
        rows = 1;
      };
      titlebarButtons = {
        right = [ "minimize" "maximize" "close" ];
        left = [ "keep-above-windows" ];
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

    panels = [
      {
        location = "top";
        height = 32;
        screen = "all";
        floating = true;
        opacity = "adaptive";
        widgets = [
          {
            name = "org.kde.plasma.kickoff";
            config = {
              General = {
                icon = "nix-snowflake-white";
              };
            };
          }
          "org.kde.plasma.margins-separator"
          {
            name = "org.kde.plasma.icontasks";
            config = {
              General = {
                launchers = [
                  "applications:org.kde.dolphin.desktop"
                  "applications:firefox.desktop"
                  "applications:org.kde.kate.desktop"
                  "applications:Alacritty.desktop"
                  "applications:discord.desktop"
                ];
              };
            };
          }
          "org.kde.plasma.margins-separator"
          {
            name = "org.kde.plasma.systemtray";
          }
          {
            name = "org.kde.plasma.digitalclock";
            config = {
              Appearance = {
                showDate = true;
                dateFormat = "ddd MMM d";
              };
            };
          }
          "org.kde.plasma.showdesktop"
        ];
      }
    ];

    shortcuts = {
      kwin = {
        "Overview" = "Meta+W";
        "ShowDesktop" = "Meta+D";
        "WindowClose" = "Alt+F4";
        "MaximizeWindow" = "Meta+Up";
        "MinimizeWindow" = "Meta+Down";
      };
    };

    desktop = {
      mouseActions = {
        rightClick = "contextMenu";
        middleClick = "paste";
      };
    };

    krunner = {
      position = "center";
      historyBehavior = "enableSuggestions";
    };
  };

  # KDE rice packages
  home.packages = with pkgs; [
    # Kvantum for app theming
    qt6Packages.qtstyleplugin-kvantum

    # Icon themes
    papirus-icon-theme

    # Cursor
    bibata-cursors

    # Fonts
    jetbrains-mono
    ibm-plex
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-color-emoji

    # Catppuccin color schemes for KDE
    catppuccin-kde

    # KDE packages
    kdePackages.dolphin
    kdePackages.kate
    kdePackages.spectacle
    kdePackages.kcalc
    kdePackages.gwenview
    kdePackages.ark
    kdePackages.discover
    kdePackages.filelight
    kdePackages.kdeconnect-kde

    # Wayland utilities
    wl-clipboard
    wayland-utils
  ];

  # Kvantum theme config
  xdg.configFile."Kvantum/kvantum.kvconfig".text = ''
    [General]
    theme=CatppuccinMocha
  '';

  # GTK theme for consistency
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

  # Qt theme
  qt = {
    enable = true;
    platformTheme.name = "qtct";
    style = {
      name = "kvantum-dark";
    };
  };

  # Alacritty - Catppuccin Mocha full theme
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
        hints = {
          start = {
            foreground = "#1e1e2e";
            background = "#f9e2af";
          };
          end = {
            foreground = "#1e1e2e";
            background = "#f9e2af";
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
