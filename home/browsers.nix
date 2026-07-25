{ pkgs, ... }:

{
  home.activation.floorpTheme = ''
    profile="$(find ~/.floorp -mindepth 1 -maxdepth 1 -type d -name '*.default' | head -1)"
    if [ -n "$profile" ]; then
      mkdir -p "$profile/chrome"

      PALETTE_DIR="$HOME/.local/state/noctalia/community-palettes"
      CATALOG="$PALETTE_DIR/.catalog/palettes.json"
      SETTINGS="$HOME/.local/state/noctalia/settings.toml"

      PALETTE_NAME=""
      if [ -f "$SETTINGS" ]; then
        PALETTE_NAME=$(grep '^community_palette' "$SETTINGS" | head -1 | sed 's/^community_palette[[:space:]]*=[[:space:]]*"\(.*\)"/\1/')
        if [ -z "$PALETTE_NAME" ]; then
          PALETTE_NAME=$(grep '^builtin' "$SETTINGS" | head -1 | sed 's/^builtin[[:space:]]*=[[:space:]]*"\(.*\)"/\1/')
        fi
      fi

      PALETTE_JSON=""
      if [ -n "$PALETTE_NAME" ] && [ -f "$CATALOG" ]; then
        PALETTE_JSON=$(jq -r --arg name "$PALETTE_NAME" '.[] | select(.name == $name) | .dark // empty' "$CATALOG" 2>/dev/null)
      fi

      if [ -z "$PALETTE_JSON" ]; then
        PALETTE_JSON='{"primary":"#39BAE6","secondary":"#AAD94C","tertiary":"#E6B450","error":"#D95757","surface":"#0B0E14","surfaceVariant":"#1E222A"}'
      fi

      SURFACE=$(echo "$PALETTE_JSON" | jq -r '.surface // "#0B0E14"')
      SURFACE_VAR=$(echo "$PALETTE_JSON" | jq -r '.surfaceVariant // "#1E222A"')
      PRIMARY=$(echo "$PALETTE_JSON" | jq -r '.primary // "#39BAE6"')
      SECONDARY=$(echo "$PALETTE_JSON" | jq -r '.secondary // "#AAD94C"')
      TERTIARY=$(echo "$PALETTE_JSON" | jq -r '.tertiary // "#E6B450"')
      ERROR=$(echo "$PALETTE_JSON" | jq -r '.error // "#D95757"')

      R=$(printf '%d' "0x$(echo "$SURFACE" | cut -c2-3)")
      G=$(printf '%d' "0x$(echo "$SURFACE" | cut -c4-5)")
      B=$(printf '%d' "0x$(echo "$SURFACE" | cut -c6-7)")
      LUMA=$(( (R * 299 + G * 587 + B * 114) / 1000 ))
      if [ "$LUMA" -lt 128 ]; then
        FG="#D1D1C7"
      else
        FG="#1e1e2e"
      fi

      cat > "$profile/chrome/userChrome.css" << UACHROME
:root {
  /* Main Colors */
  --toolbar-bgcolor: $SURFACE !important;
  --toolbar-color: $FG !important;
  --toolbar-bordercolor: $SURFACE_VAR !important;
  --toolbarbutton-hover-background: $SURFACE_VAR !important;
  --toolbarbutton-active-background: $SURFACE_VAR !important;
  --lwt-accent-color: $SURFACE !important;
  --lwt-text-color: $FG !important;

  /* Address Bar (URL Bar) Noctalia Variables */
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

  /* Tabs & Sidebar */
  --tab-selected-color: $FG !important;
  --sidebar-bgcolor: $SURFACE !important;
  --sidebar-text-color: $FG !important;
  --sidebar-border-color: $SURFACE_VAR !important;
  --bookmark-text-color: $FG !important;
  --chrome-content-separator-color: $SURFACE_VAR !important;

  /* Popups & Panels */
  --panel-background: $SURFACE !important;
  --panel-color: $FG !important;
  --panel-border-color: $SURFACE_VAR !important;
}

/* Global Selection */
::selection {
  background-color: $PRIMARY !important;
  color: $SURFACE !important;
}

/* Toolbars & Nav */
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

/* Sidebar */
#sidebar-box, #sidebar {
  background: $SURFACE !important;
  color: $FG !important;
}
#sidebar-header {
  background: $SURFACE_VAR !important;
  color: $FG !important;
}

/* Tabs */
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

/* Address Bar (URL Bar) */
#urlbar,
#urlbar-background,
#urlbar-input-container {
  background-color: $SURFACE_VAR !important;
  border-radius: 8px !important;
  color: $FG !important;
}
#urlbar-background {
  border: 1px solid $SURFACE_VAR !important;
}

/* Active / Open / Focused / Breakout Popup State */
#urlbar[open],
#urlbar[open="true"],
#urlbar[focused],
#urlbar[focused="true"],
#urlbar[breakout][breakout-extend] {
  --urlbar-open-background: $SURFACE_VAR !important;
  --urlbar-box-background: $SURFACE_VAR !important;
}

#urlbar[open] > #urlbar-background,
#urlbar[open="true"] > #urlbar-background,
#urlbar[focused] > #urlbar-background,
#urlbar[focused="true"] > #urlbar-background,
#urlbar[breakout][breakout-extend] > #urlbar-background {
  background-color: $SURFACE_VAR !important;
  background: $SURFACE_VAR !important;
  border-color: $PRIMARY !important;
}

#urlbar-input-container,
#urlbar-input-container[focus-within],
#urlbar[open] #urlbar-input-container,
#urlbar[focused] #urlbar-input-container {
  background-color: transparent !important;
  background: transparent !important;
  color: $FG !important;
}

#urlbar-input,
.urlbar-input-box {
  color: $FG !important;
  background-color: transparent !important;
}

/* Text selection / highlight inside address bar input */
#urlbar-input::selection,
#urlbar-input::-moz-selection {
  background-color: $PRIMARY !important;
  color: $SURFACE !important;
}

/* URL Bar Suggestions Dropdown Popup */
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

/* Security Lock Icon */
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
user_pref("extensions.activeThemeID", "default-theme@mozilla.org");
USERJS
    fi
  '';
}
