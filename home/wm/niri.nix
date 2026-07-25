{ inputs, pkgs, ... }:

{
  home.packages = [ pkgs.xwayland-satellite ];

  programs.niri = {
    enable = true;
    package = inputs.niri.packages.${pkgs.stdenv.hostPlatform.system}.niri-stable;

    settings = {
      prefer-no-csd = true;

      input = {
        keyboard.xkb = {
          layout = "us";
        };
        mouse = {
          natural-scroll = false;
        };
      };

      outputs = {
        "DP-2" = {
          mode = {
            width = 3440;
            height = 1440;
            refresh = 143.97;
          };
          scale = 1;
          variable-refresh-rate = true;
          position = {
            x = 0;
            y = 0;
          };
        };
      };

      layout = {
        default-column-width.proportion = 0.5;
        center-focused-column = "on-overflow";
        background-color = "transparent";
        preset-column-widths = [
          { proportion = 0.33333; }
          { proportion = 0.5; }
          { proportion = 0.66667; }
          { proportion = 1.0; }
        ];
        gaps = 8;

        focus-ring = {
          enable = true;
          width = 2;
          active.color = "#cba6f7";
          inactive.color = "#313244";
        };

        shadow = {
          enable = true;
          color = "#00000066";
          offset = {
            x = 2;
            y = 4;
          };
          softness = 16;
        };
      };

      animations = {
        enable = true;
      };

      workspaces = {
        "term" = {};
        "web" = {};
        "gaming" = {};
        "4" = {};
        "5" = {};
      };

      spawn-at-startup = [
        { argv = [ "noctalia" ]; }
        { argv = [ "alacritty" ]; }
        { sh = "sleep 2 && floorp"; }
        { sh = "sleep 4 && steam"; }
      ];

      window-rules = [
        {
          geometry-corner-radius = {
            top-left = 12.0;
            top-right = 12.0;
            bottom-right = 12.0;
            bottom-left = 12.0;
          };
          clip-to-geometry = true;
        }

        {
          matches = [{ app-id = "dev.noctalia.Noctalia"; }];
          open-floating = true;
          default-column-width = { fixed = 1080; };
          default-window-height = { fixed = 920; };
        }

        {
          matches = [{ app-id = "Alacritty"; }];
          open-on-workspace = "term";
        }

        {
          matches = [{ app-id = "org.kde.konsole"; }];
          open-on-workspace = "term";
        }

        {
          matches = [{ app-id = "floorp"; }];
          open-on-workspace = "web";
        }

        {
          matches = [{ app-id = "io.github.Aylur.floorp"; }];
          open-on-workspace = "web";
        }

        {
          matches = [{ app-id = "steam"; }];
          open-on-workspace = "gaming";
        }

        {
          matches = [{ app-id = "steam_app"; }];
          open-on-workspace = "gaming";
        }

        {
          matches = [{ title = "^(.*) - Steam$"; is-focused = false; }];
          open-fullscreen = true;
        }
      ];

      layer-rules = [
        {
          matches = [{ namespace = "^noctalia-wallpaper$"; }];
          place-within-backdrop = true;
        }
      ];

      binds = {
        # Core Applications & Launchers (Both Super and Alt work)
        "Super+Return".action.spawn = [ "alacritty" ];
        "Alt+Return".action.spawn = [ "alacritty" ];
        "Super+Space".action.spawn = [ "fuzzel" ];
        "Alt+Space".action.spawn = [ "fuzzel" ];
        "Super+Q".action.close-window = [];
        "Alt+Q".action.close-window = [];
        "Super+M".action.quit = [];
        "Alt+R".action.spawn = [ "sh" "-c" "niri msg action load-config-file && notify-send 'Niri' 'Configuration reloaded!'" ];

        # Noctalia IPC Binds
        "Mod+Space".action.spawn = [ "sh" "-c" "noctalia msg panel-toggle launcher" ];
        "Mod+S".action.spawn = [ "sh" "-c" "noctalia msg panel-toggle control-center" ];
        "Mod+Comma".action.spawn = [ "sh" "-c" "noctalia msg settings-toggle" ];
        "Mod+O".action.spawn = [ "sh" "-c" "noctalia msg window-switcher" ];
        "Alt+Tab".action.toggle-overview = [];

        # Media & Hardware Keys
        "XF86AudioRaiseVolume".action.spawn = [ "sh" "-c" "wpctl set-volume @DEFAULT_SINK@ 5%+" ];
        "XF86AudioLowerVolume".action.spawn = [ "sh" "-c" "wpctl set-volume @DEFAULT_SINK@ 5%-" ];
        "XF86AudioMute".action.spawn = [ "sh" "-c" "wpctl set-mute @DEFAULT_SINK@ toggle" ];
        "XF86MonBrightnessUp".action.spawn = [ "sh" "-c" "noctalia msg brightness-up" ];
        "XF86MonBrightnessDown".action.spawn = [ "sh" "-c" "noctalia msg brightness-down" ];

        # Focus Navigation (Vim-style H/J/K/L & Arrow keys)
        "Super+H".action.focus-column-left = [];
        "Alt+H".action.focus-column-left = [];
        "Super+L".action.focus-column-right = [];
        "Alt+L".action.focus-column-right = [];
        "Super+J".action.focus-window-down = [];
        "Alt+J".action.focus-window-down = [];
        "Super+K".action.focus-window-up = [];
        "Alt+K".action.focus-window-up = [];
        "Super+Left".action.focus-column-left = [];
        "Super+Right".action.focus-column-right = [];

        # Move Window / Column (Vim-style Shift+H/J/K/L)
        "Super+Shift+H".action.move-column-left = [];
        "Alt+Shift+H".action.move-column-left = [];
        "Super+Shift+L".action.move-column-right = [];
        "Alt+Shift+L".action.move-column-right = [];
        "Super+Shift+J".action.move-window-down = [];
        "Alt+Shift+J".action.move-window-down = [];
        "Super+Shift+K".action.move-window-up = [];
        "Alt+Shift+K".action.move-window-up = [];

        # Window States (Fullscreen, Maximize, Floating)
        "Super+F".action.fullscreen-window = [];
        "Alt+F".action.fullscreen-window = [];
        "Mod+F".action.maximize-column = [];
        "Super+V".action.toggle-window-floating = [];
        "Alt+V".action.toggle-window-floating = [];

        # Workspaces (Focus 1..5)
        "Super+1".action.focus-workspace = "term";
        "Super+2".action.focus-workspace = "web";
        "Super+3".action.focus-workspace = "gaming";
        "Super+4".action.focus-workspace = 4;
        "Super+5".action.focus-workspace = 5;
        "Alt+1".action.focus-workspace = "term";
        "Alt+2".action.focus-workspace = "web";
        "Alt+3".action.focus-workspace = "gaming";
        "Alt+4".action.focus-workspace = 4;
        "Alt+5".action.focus-workspace = 5;

        # Move Window to Workspace 1..5
        "Super+Shift+1".action.move-window-to-workspace = "term";
        "Super+Shift+2".action.move-window-to-workspace = "web";
        "Super+Shift+3".action.move-window-to-workspace = "gaming";
        "Super+Shift+4".action.move-window-to-workspace = 4;
        "Super+Shift+5".action.move-window-to-workspace = 5;
        "Alt+Shift+1".action.move-window-to-workspace = "term";
        "Alt+Shift+2".action.move-window-to-workspace = "web";
        "Alt+Shift+3".action.move-window-to-workspace = "gaming";

        # Column Sizing & Preset Resizing
        "Alt+Minus".action.set-column-width = "-10%";
        "Alt+Equal".action.set-column-width = "+10%";
        "Super+R".action.switch-preset-column-width = [];
        "Alt+R_Shift".action.switch-preset-column-width = [];

        # Screenshots (No Print key required! Super+Shift+S, Super+P, Alt+P, Print)
        "Print".action.screenshot = [];
        "Super+Shift+S".action.spawn = [ "sh" "-c" "mkdir -p $HOME/Pictures/Screenshots && g=$(slurp) && [ -n \"$g\" ] && grim -g \"$g\" - | satty --filename - --output-filename $HOME/Pictures/Screenshots/$(date +%Y%m%d%H%M%S).png" ];
        "Super+P".action.spawn = [ "sh" "-c" "mkdir -p $HOME/Pictures/Screenshots && g=$(slurp) && [ -n \"$g\" ] && f=$HOME/Pictures/Screenshots/$(date +%Y%m%d%H%M%S).png && grim -g \"$g\" \"$f\" && wl-copy --type image/png < \"$f\"" ];
        "Alt+P".action.spawn = [ "sh" "-c" "mkdir -p $HOME/Pictures/Screenshots && g=$(slurp) && [ -n \"$g\" ] && f=$HOME/Pictures/Screenshots/$(date +%Y%m%d%H%M%S).png && grim -g \"$g\" \"$f\" && wl-copy --type image/png < \"$f\"" ];
        "Super+Shift+P".action.spawn = [ "sh" "-c" "mkdir -p $HOME/Pictures/Screenshots && f=$HOME/Pictures/Screenshots/$(date +%Y%m%d%H%M%S).png && grim \"$f\" && wl-copy --type image/png < \"$f\"" ];

        "Super+Alt+L".action.spawn = [ "sh" "-c" "swaylock" ];
      };
    };
  };
}
