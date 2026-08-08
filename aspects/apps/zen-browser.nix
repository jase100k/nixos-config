{ config, pkgs, inputs, ... }:

{
  home-manager.users.jason = {
    home.packages = [
      inputs.zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.default
    ];
    home.activation.zenBrowserTheme = config.home-manager.users.jason.lib.dag.entryAfter [ "writeBoundary" ] ''
      THEME_FILE="$HOME/.config/alacritty/themes/noctalia.toml"
      BG="#0f1416"
      FG="#dee3e5"
      ACCENT="#bec5eb"

      if [ -f "$THEME_FILE" ]; then
        BG_TMP=$(grep -E '^\s*background\s*=' "$THEME_FILE" | head -n 1 | cut -d "'" -f 2)
        FG_TMP=$(grep -E '^\s*foreground\s*=' "$THEME_FILE" | head -n 1 | cut -d "'" -f 2)
        PRI_TMP=$(grep -E '^\s*magenta\s*=' "$THEME_FILE" | head -n 1 | cut -d "'" -f 2)
        [ -z "$PRI_TMP" ] && PRI_TMP=$(grep -E '^\s*blue\s*=' "$THEME_FILE" | head -n 1 | cut -d "'" -f 2)
        [ -n "$BG_TMP" ] && BG="$BG_TMP"
        [ -n "$FG_TMP" ] && FG="$FG_TMP"
        [ -n "$PRI_TMP" ] && ACCENT="$PRI_TMP"
      fi

      find "$HOME/.config/zen" -mindepth 1 -maxdepth 1 -type d \( -name '*default*' -o -name '*Default*' -o -name '*Profile*' \) -print0 2>/dev/null | while IFS= read -r -d "" profile; do
        if [ -d "$profile" ]; then
          mkdir -p "$profile/chrome"
          cat << 'USERJS' > "$profile/user.js"
user_pref("devtools.chrome.enabled", true);
user_pref("toolkit.legacyUserProfileCustomizations.stylesheets", true);
user_pref("svg.context-properties.content.enabled", true);
user_pref("ui.systemUsesDarkTheme", 1);
user_pref("layout.css.prefers-color-scheme.content-override", 0);
user_pref("zen.theme.allow-system-accent-color", false);
USERJS

          cat << EOF > "$profile/chrome/userChrome.css"
:root, #main-window, body {
  --zen-primary-color: $ACCENT !important;
  --zen-colors-primary: $ACCENT !important;
  --zen-colors-secondary: $BG !important;
  --zen-colors-tertiary: $BG !important;
  --zen-colors-border: $ACCENT !important;
  --zen-themed-toolbar-bg: $BG !important;
  --zen-main-browser-background: $BG !important;
  --zen-urlbar-background: $BG !important;
  --toolbar-bgcolor: $BG !important;
  --toolbar-color: $FG !important;
  --sidebar-bgcolor: $BG !important;
  --sidebar-text-color: $FG !important;
  --lwt-accent-color: $ACCENT !important;
  --lwt-text-color: $FG !important;
}

#navigator-toolbox,
#zen-tabbox-wrapper,
#zen-sidebar-web-wrapper,
.sidebar-panel,
#sidebar-box,
#sidebar-header,
#browser,
#main-window {
  background-color: $BG !important;
  color: $FG !important;
}

.tabbrowser-tab[selected="true"] .tab-background,
.tab-background[selected="true"] {
  background-color: color-mix(in srgb, $ACCENT 25%, $BG) !important;
  border: 1px solid $ACCENT !important;
}

.tabbrowser-tab[selected="true"] .tab-label {
  color: $ACCENT !important;
  font-weight: bold !important;
}

#urlbar-background {
  background-color: color-mix(in srgb, $ACCENT 10%, $BG) !important;
  border: 1px solid $ACCENT !important;
}

#zen-workspaces-button,
.zen-current-workspace-indicator {
  color: $ACCENT !important;
  fill: $ACCENT !important;
}
EOF
        fi
      done
    '';
  };
}






