{ config, pkgs, inputs, ... }:

{
  home-manager.users.jason = {
    home.packages = [
      inputs.zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.default
      pkgs.pywalfox-native
    ];

    systemd.user.services.pywalfox = {
      Unit = {
        Description = "Pywalfox daemon for live browser theming";
      };
      Service = {
        ExecStart = "${pkgs.pywalfox-native}/bin/pywalfox start";
        Restart = "on-failure";
      };
      Install = {
        WantedBy = [ "default.target" ];
      };
    };

    home.activation.zenBrowserTheme = config.home-manager.users.jason.lib.dag.entryAfter [ "writeBoundary" ] ''

      if command -v pywalfox >/dev/null 2>&1; then
        pywalfox install --profile-path "$HOME/.config/zen" 2>/dev/null || true
      fi

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
:root {
  --zen-main-browser-background: var(--theme-sidebar-background, var(--theme-body-color, $BG)) !important;
  --zen-themed-toolbar-bg: var(--theme-sidebar-background, var(--theme-body-color, $BG)) !important;
  --zen-urlbar-background: var(--theme-secondary-color, var(--theme-sidebar-background, $BG)) !important;
  --zen-colors-secondary: var(--theme-secondary-color, var(--theme-sidebar-background, $BG)) !important;
  --zen-colors-tertiary: var(--theme-sidebar-background, $BG) !important;
  --zen-primary-color: var(--theme-accent-color, $ACCENT) !important;
  --zen-colors-border: var(--theme-accent-color, $ACCENT) !important;
}

#navigator-toolbox,
#zen-tabbox-wrapper,
#zen-sidebar-web-wrapper,
.sidebar-panel,
#sidebar-box,
#sidebar-header,
#browser,
#main-window,
#zen-workspaces-button,
#zen-appcontent-navbar-container,
.zen-sidebar-panel {
  background-color: var(--theme-sidebar-background, var(--theme-body-color, $BG)) !important;
  background: var(--theme-sidebar-background, var(--theme-body-color, $BG)) !important;
  color: var(--theme-sidebar-color, var(--theme-text-color, $FG)) !important;
}

.tab-label,
#zen-workspaces-button,
.sidebar-placesTree,
.zen-current-workspace-indicator {
  color: var(--theme-sidebar-color, var(--theme-text-color, $FG)) !important;
}

.tabbrowser-tab[selected="true"] .tab-background,
.tab-background[selected="true"] {
  background-color: color-mix(in srgb, var(--theme-accent-color, $ACCENT) 25%, transparent) !important;
  border: 1px solid var(--theme-accent-color, $ACCENT) !important;
}

.tabbrowser-tab[selected="true"] .tab-label {
  color: var(--theme-accent-color, $ACCENT) !important;
  font-weight: bold !important;
}

#urlbar-background {
  background-color: color-mix(in srgb, var(--theme-accent-color, $ACCENT) 10%, transparent) !important;
  border: 1px solid var(--theme-accent-color, $ACCENT) !important;
}
EOF
        fi
      done
    '';
  };
}






