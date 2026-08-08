{ config, pkgs, ... }:

{
  home-manager.users.jason = {
    home.packages = [ pkgs.floorp-bin ];

    home.activation.browserThemes = ''
      THEME_FILE="$HOME/.config/alacritty/themes/noctalia.toml"
      BG="#0b0e14"
      FG="#d1d1c7"
      PRIMARY="#39bae6"

      if [ -f "$THEME_FILE" ]; then
        BG_TMP=$(grep -E '^\s*background\s*=' "$THEME_FILE" | head -n 1 | cut -d "'" -f 2)
        FG_TMP=$(grep -E '^\s*foreground\s*=' "$THEME_FILE" | head -n 1 | cut -d "'" -f 2)
        PRI_TMP=$(grep -E '^\s*blue\s*=' "$THEME_FILE" | head -n 1 | cut -d "'" -f 2)
        [ -n "$BG_TMP" ] && BG="$BG_TMP"
        [ -n "$FG_TMP" ] && FG="$FG_TMP"
        [ -n "$PRI_TMP" ] && PRIMARY="$PRI_TMP"
      fi

      SURFACE="$BG"
      SURFACE_VAR="$BG"
      SECONDARY="$PRIMARY"
      ERROR="#d95757"


      for profile in $(find ~/.floorp -mindepth 1 -maxdepth 1 -type d \( -name '*.default*' -o -name '*default*' \) 2>/dev/null); do
        if [ -d "$profile" ]; then
          mkdir -p "$profile/chrome"

          cat > "$profile/chrome/userChrome.css" << UACHROME

:root {
  --toolbar-bgcolor: $SURFACE !important;
  --toolbar-color: $FG !important;
  --toolbar-bordercolor: $SURFACE_VAR !important;
  --toolbarbutton-hover-background: $SURFACE_VAR !important;
  --toolbarbutton-active-background: $SURFACE_VAR !important;
  --lwt-accent-color: $SURFACE !important;
  --lwt-text-color: $FG !important;

  --toolbar-field-background-color: $SURFACE_VAR !important;
  --toolbar-field-focus-background-color: $SURFACE_VAR !important;
  --toolbar-field-color: $FG !important;
  --toolbar-field-focus-color: $FG !important;
  --toolbar-field-border-color: $SURFACE_VAR !important;
  --toolbar-field-focus-border-color: $PRIMARY !important;
  --lwt-toolbar-field-background-color: $SURFACE_VAR !important;
  --lwt-toolbar-field-focus-background-color: $SURFACE_VAR !important;
  --lwt-toolbar-field-color: $FG !important;
  --lwt-toolbar-field-focus-color: $FG !important;
  --urlbar-box-background: $SURFACE_VAR !important;
  --urlbar-box-bgcolor: $SURFACE_VAR !important;
  --urlbar-open-background: $SURFACE_VAR !important;
  --urlbar-box-focus-background: $SURFACE_VAR !important;
  --urlbarView-highlight-background: $SURFACE_VAR !important;

  --tab-selected-color: $FG !important;
  --sidebar-bgcolor: $SURFACE !important;
  --sidebar-text-color: $FG !important;
  --sidebar-border-color: $SURFACE_VAR !important;
  --bookmark-text-color: $FG !important;
  --chrome-content-separator-color: $SURFACE_VAR !important;

  --panel-background: $SURFACE !important;
  --panel-color: $FG !important;
  --panel-border-color: $SURFACE_VAR !important;
}

::selection {
  background-color: $PRIMARY !important;
  color: $SURFACE !important;
}

#nav-bar,
#PersonalToolbar,
#TabsToolbar,
#sidebar-box,
#browser-bottombox,
toolbar[type="menubar"] {
  background-color: $SURFACE !important;
  color: $FG !important;
  border-color: $SURFACE_VAR !important;
}

#PersonalToolbar .toolbarbutton-text,
#PersonalToolbar .bookmark-item .toolbarbutton-icon,
#PersonalToolbar toolbarbutton {
  color: $FG !important;
  fill: $FG !important;
}

#sidebar-box, #sidebar {
  background: $SURFACE !important;
  color: $FG !important;
}
#sidebar-header {
  background: $SURFACE_VAR !important;
  color: $FG !important;
}

.tabbrowser-tab {
  color: $FG !important;
}
.tab-background {
  background: $SURFACE_VAR !important;
  border: 1px solid $SURFACE_VAR !important;
  border-radius: 8px !important;
  margin: 2px 4px !important;
}
.tab-background[selected="true"] {
  background: $SURFACE_VAR !important;
  border-color: $PRIMARY !important;
}

#urlbar,
#urlbar-background,
#urlbar-input-container {
  background-color: $SURFACE_VAR !important;
  border-radius: 8px !important;
  color: $FG !important;
}

#urlbar[open],
#urlbar[open="true"],
#urlbar[focused],
#urlbar[focused="true"],
#urlbar[breakout][breakout-extend] {
  --urlbar-open-background: $SURFACE_VAR !important;
  --urlbar-box-background: $SURFACE_VAR !important;
  --toolbar-field-focus-background-color: $SURFACE_VAR !important;
  --lwt-toolbar-field-focus-background-color: $SURFACE_VAR !important;
}

#urlbar-background,
#urlbar[open] > #urlbar-background,
#urlbar[open="true"] > #urlbar-background,
#urlbar[focused] > #urlbar-background,
#urlbar[focused="true"] > #urlbar-background,
#urlbar[breakout][breakout-extend] > #urlbar-background {
  background-color: $SURFACE_VAR !important;
  background: $SURFACE_VAR !important;
  border: 1px solid $SURFACE_VAR !important;
}

#urlbar[open] > #urlbar-background,
#urlbar[open="true"] > #urlbar-background,
#urlbar[focused] > #urlbar-background,
#urlbar[focused="true"] > #urlbar-background,
#urlbar[breakout][breakout-extend] > #urlbar-background {
  border-color: $PRIMARY !important;
}

#urlbar *,
#urlbar-input-container,
#urlbar-input-container *,
.urlbar-input-box,
.urlbar-input-box *,
#urlbar-input,
#urlbar-input:focus,
#urlbar-input[focused] {
  background-color: transparent !important;
  background: transparent !important;
  color: $FG !important;
}

#urlbar-input::selection,
#urlbar-input::-moz-selection {
  background-color: $PRIMARY !important;
  color: $SURFACE !important;
}

#urlbar-results,
.urlbarView,
.urlbarView-body-outer,
.urlbarView-body-inner,
.urlbarView-results {
  background-color: $SURFACE !important;
  color: $FG !important;
  border: 1px solid $SURFACE_VAR !important;
  border-radius: 8px !important;
}
.urlbarView-row,
.urlbarView-row-inner {
  background-color: transparent !important;
  color: $FG !important;
}
.urlbarView-row[selected],
.urlbarView-row:hover {
  background-color: $SURFACE_VAR !important;
  color: $FG !important;
}
.urlbarView-highlight {
  color: $PRIMARY !important;
}

#identity-box[pageproxystate="valid"].verifiedDomain #identity-icon,
#identity-box[pageproxystate="valid"].chromeUI #identity-icon {
  fill: $SECONDARY !important;
}
#identity-box.not-secure #identity-icon {
  fill: $ERROR !important;
}

#status-bar {
  background: $SURFACE !important;
  color: $FG !important;
}

#back-button > .toolbarbutton-icon,
#forward-button > .toolbarbutton-icon {
  fill: $FG !important;
}
UACHROME

          cat > "$profile/chrome/userContent.css" << UACSS
@-moz-document url-prefix(about:), url-prefix(moz-extension://) {
  body, html {
    background-color: $SURFACE !important;
    color: $FG !important;
  }
}
UACSS

          cat > "$profile/user.js" << 'USERJS'
user_pref("toolkit.legacyUserProfileCustomizations.stylesheets", true);
user_pref("svg.context-properties.content.enabled", true);
user_pref("design.interface", "proton");
user_pref("extensions.activeThemeID", "firefox-compact-dark@mozilla.org");
user_pref("ui.systemUsesDarkTheme", 1);
user_pref("layout.css.prefers-color-scheme.content-override", 0);
USERJS
        fi
      done
    '';
  };
}
