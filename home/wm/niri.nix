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
        gaps = 4;

        shadow = {
          enable = true;
          color = "#00000080";
          offset = {
            x = 2;
            y = 2;
          };
          softness = 12;
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
        "Alt+Return".action.spawn = [ "alacritty" ];
        "Alt+Space".action.spawn = [ "fuzzel" ];
        "Alt+Q".action.close-window = [];
        "Mod+M".action.quit = [];
        "Alt+R".action.spawn = [ "sh" "-c" "niri msg action reload-config" ];

        "Mod+Space".action.spawn = [ "sh" "-c" "noctalia msg panel-toggle launcher" ];
        "Mod+S".action.spawn = [ "sh" "-c" "noctalia msg panel-toggle control-center" ];
        "Mod+Comma".action.spawn = [ "sh" "-c" "noctalia msg settings-toggle" ];
        "Alt+Tab".action.toggle-overview = [];

        "XF86AudioRaiseVolume".action.spawn = [ "sh" "-c" "wpctl set-volume @DEFAULT_SINK@ 5%+" ];
        "XF86AudioLowerVolume".action.spawn = [ "sh" "-c" "wpctl set-volume @DEFAULT_SINK@ 5%-" ];
        "XF86AudioMute".action.spawn = [ "sh" "-c" "wpctl set-mute @DEFAULT_SINK@ toggle" ];
        "XF86MonBrightnessUp".action.spawn = [ "sh" "-c" "noctalia msg brightness-up" ];
        "XF86MonBrightnessDown".action.spawn = [ "sh" "-c" "noctalia msg brightness-down" ];

        "Alt+H".action.focus-column-left = [];
        "Alt+L".action.focus-column-right = [];
        "Alt+J".action.focus-window-down = [];
        "Alt+K".action.focus-window-up = [];
        "Mod+U".action.focus-workspace-down = [];
        "Mod+I".action.focus-workspace-up = [];

        "Mod+Shift+H".action.move-column-left = [];
        "Mod+Shift+L".action.move-column-right = [];
        "Mod+Shift+J".action.move-window-down = [];
        "Mod+Shift+K".action.move-window-up = [];

        "Mod+Ctrl+H".action.move-column-left = [];
        "Mod+Ctrl+J".action.move-window-down = [];
        "Mod+Ctrl+K".action.move-window-up = [];
        "Mod+Ctrl+L".action.move-column-right = [];

        "Alt+F".action.fullscreen-window = [];
        "Mod+F".action.maximize-column = [];
        "Mod+V".action.toggle-window-floating = [];
        "Mod+Shift+F".action.fullscreen-window = [];

        "Mod+1".action.focus-workspace = "term";
        "Mod+2".action.focus-workspace = "web";
        "Mod+3".action.focus-workspace = "gaming";
        "Mod+4".action.focus-workspace = 4;
        "Mod+5".action.focus-workspace = 5;

        "Ctrl+1".action.focus-workspace = "term";
        "Ctrl+2".action.focus-workspace = "web";
        "Ctrl+3".action.focus-workspace = "gaming";
        "Ctrl+4".action.focus-workspace = 4;
        "Ctrl+5".action.focus-workspace = 5;

        "Alt+1".action.move-window-to-workspace = "term";
        "Alt+2".action.move-window-to-workspace = "web";
        "Alt+3".action.move-window-to-workspace = "gaming";
        "Alt+4".action.move-window-to-workspace = 4;
        "Alt+5".action.move-window-to-workspace = 5;

        "Mod+Left".action.focus-column-left = [];
        "Mod+Right".action.focus-column-right = [];

        "Alt+Minus".action.set-column-width = "-10%";
        "Alt+Equal".action.set-column-width = "+10%";
        "Mod+R".action.switch-preset-column-width = [];

        "Mod+BracketLeft".action.consume-or-expel-window-left = [];
        "Mod+BracketRight".action.consume-or-expel-window-right = [];

        # Screenshots (Wayland grim + slurp + satty + wl-clipboard)
        "Print".action.screenshot = [];
        "Alt+P".action.spawn = [ "sh" "-c" "mkdir -p $HOME/Pictures/Screenshots && g=$(slurp) && [ -n \"$g\" ] && f=$HOME/Pictures/Screenshots/$(date +%Y%m%d%H%M%S).png && grim -g \"$g\" \"$f\" && wl-copy --type image/png < \"$f\"" ];
        "Alt+Shift+P".action.spawn = [ "sh" "-c" "mkdir -p $HOME/Pictures/Screenshots && f=$HOME/Pictures/Screenshots/$(date +%Y%m%d%H%M%S).png && grim \"$f\" && wl-copy --type image/png < \"$f\"" ];
        "Alt+Ctrl+P".action.spawn = [ "sh" "-c" "f=$(mktemp -t shot-XXXXXX.png) && grim \"$f\" && wl-copy --type image/png < \"$f\" && rm -f \"$f\"" ];
        "Super+Shift+S".action.spawn = [ "sh" "-c" "mkdir -p $HOME/Pictures/Screenshots && g=$(slurp) && [ -n \"$g\" ] && grim -g \"$g\" - | satty --filename - --output-filename $HOME/Pictures/Screenshots/$(date +%Y%m%d%H%M%S).png" ];

        "Mod+O".action.spawn = [ "sh" "-c" "noctalia msg window-switcher" ];

        "Super+Alt+L".action.spawn = [ "sh" "-c" "swaylock" ];
      };
    };
  };
}
