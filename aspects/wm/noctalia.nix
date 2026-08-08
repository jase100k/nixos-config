{ config, pkgs, ... }:

let
  floorp-theme-sync = pkgs.writeShellScript "floorp-theme-sync" ''
    THEME_FILE="$HOME/.config/alacritty/themes/noctalia.toml"
    if [ -f "$THEME_FILE" ]; then
      BG=$(grep -E '^\s*background\s*=' "$THEME_FILE" | head -n 1 | cut -d "'" -f 2)
      FG=$(grep -E '^\s*foreground\s*=' "$THEME_FILE" | head -n 1 | cut -d "'" -f 2)
      ACCENT=$(grep -E '^\s*blue\s*=' "$THEME_FILE" | head -n 1 | cut -d "'" -f 2)
      BG=''${BG:-#1e1010}
      FG=''${FG:-#f8dcdb}
      ACCENT=''${ACCENT:-$FG}

      for PROFILE in $(find "$HOME/.floorp" -mindepth 1 -maxdepth 1 -type d \( -name '*default*' -o -name '*Default*' -o -name '*Profile*' \) 2>/dev/null); do
        if [ -d "$PROFILE" ]; then
          mkdir -p "$PROFILE/chrome"
          cat << EOF > "$PROFILE/chrome/userChrome.css"
:root {
  --toolbar-bgcolor: $BG !important;
  --toolbar-color: $FG !important;
  --toolbar-bordercolor: $BG !important;
  --toolbarbutton-hover-background: $BG !important;
  --toolbarbutton-active-background: $BG !important;
  --lwt-accent-color: $BG !important;
  --lwt-text-color: $FG !important;
  --toolbar-field-background-color: $BG !important;
  --toolbar-field-focus-background-color: $BG !important;
  --toolbar-field-color: $FG !important;
  --toolbar-field-focus-color: $FG !important;
  --toolbar-field-border-color: $BG !important;
  --toolbar-field-focus-border-color: $ACCENT !important;
  --urlbar-box-background: $BG !important;
  --urlbar-box-bgcolor: $BG !important;
  --tab-selected-color: $FG !important;
  --sidebar-bgcolor: $BG !important;
  --sidebar-text-color: $FG !important;
}
#nav-bar, #PersonalToolbar, #TabsToolbar, #sidebar-box, #browser-bottombox {
  background-color: $BG !important;
  color: $FG !important;
}
.tab-background[selected="true"] {
  background: $BG !important;
  border-color: $ACCENT !important;
}
#urlbar, #urlbar-background, #urlbar-input-container {
  background-color: $BG !important;
  color: $FG !important;
}
EOF
        fi
      done
    fi
  '';
  zen-theme-sync = pkgs.writeShellScript "zen-theme-sync" ''
    THEME_FILE="$HOME/.config/alacritty/themes/noctalia.toml"
    if [ -f "$THEME_FILE" ]; then
      BG=$(grep -E '^\s*background\s*=' "$THEME_FILE" | head -n 1 | cut -d "'" -f 2)
      FG=$(grep -E '^\s*foreground\s*=' "$THEME_FILE" | head -n 1 | cut -d "'" -f 2)
      ACCENT=$(grep -E '^\s*magenta\s*=' "$THEME_FILE" | head -n 1 | cut -d "'" -f 2)
      [ -z "$ACCENT" ] && ACCENT=$(grep -E '^\s*blue\s*=' "$THEME_FILE" | head -n 1 | cut -d "'" -f 2)
      BG=''${BG:-#141318}
      FG=''${FG:-#e6e1e9}
      ACCENT=''${ACCENT:-$FG}

      find "$HOME/.config/zen" -mindepth 1 -maxdepth 1 -type d \( -name '*default*' -o -name '*Default*' -o -name '*Profile*' \) -print0 2>/dev/null | while IFS= read -r -d "" PROFILE; do
        if [ -d "$PROFILE" ]; then
          mkdir -p "$PROFILE/chrome"
          cat << EOF > "$PROFILE/chrome/userChrome.css"
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
    fi
  '';

in
{
  programs.noctalia = {
    enable = true;
    recommendedServices.enable = true;
  };

  home-manager.users.jason = {
    xdg.configFile."noctalia/user-templates.toml".text = ''
      [templates.antigravity_ide]
      input_path = "~/.local/state/noctalia/community-templates/antigravity/antigravity.json"
      output_path = "~/.antigravity-ide/User/settings.json"
      post_hook = "SETTINGS_FILE=\"$HOME/.antigravity-ide/User/settings.json\"; THEME_FILE=\"$HOME/.gemini/config/theme.json\"; if [ -f \"$THEME_FILE\" ] && [ -f \"$SETTINGS_FILE\" ]; then bg=$(jq -r '.userSettings.customThemeSeedsDark.background // \"#0b0e14\"' \"$THEME_FILE\"); fg=$(jq -r '.userSettings.customThemeSeedsDark.foregroundOverride // \"#d1d1c7\"' \"$THEME_FILE\"); primary=$(jq -r '.userSettings.customThemeSeedsDark.primary // \"#39bae6\"' \"$THEME_FILE\"); jq --arg bg \"$bg\" --arg fg \"$fg\" --arg primary \"$primary\" '.[\"workbench.colorTheme\"] = \"Default Dark Modern\" | .[\"workbench.colorCustomizations\"] = {\"editor.background\": $bg, \"editor.foreground\": $fg, \"sideBar.background\": $bg, \"sideBar.foreground\": $fg, \"sideBarTitle.foreground\": $fg, \"sideBarSectionHeader.background\": $bg, \"activityBar.background\": $bg, \"activityBar.foreground\": $primary, \"activityBar.activeBackground\": $bg, \"statusBar.background\": $bg, \"statusBar.foreground\": $fg, \"titleBar.activeBackground\": $bg, \"titleBar.activeForeground\": $fg, \"tab.activeBackground\": $bg, \"tab.activeForeground\": $fg, \"tab.activeBorder\": $primary, \"tab.inactiveBackground\": $bg, \"tab.inactiveForeground\": $fg, \"panel.background\": $bg, \"panel.border\": $primary, \"editorGroupHeader.tabsBackground\": $bg, \"commandCenter.background\": $bg, \"commandCenter.foreground\": $fg, \"commandCenter.border\": $primary, \"terminal.background\": $bg, \"terminal.foreground\": $fg}' \"$SETTINGS_FILE\" > \"$SETTINGS_FILE.tmp\" && cat \"$SETTINGS_FILE.tmp\" > \"$SETTINGS_FILE\" && rm -f \"$SETTINGS_FILE.tmp\"; fi"

      [templates.floorp]
      output_path = "~/.floorp/userChrome.css"
      post_hook = "${floorp-theme-sync}"

      [templates.zen_browser]
      output_path = "~/.config/zen/userChrome.css"
      post_hook = "${zen-theme-sync}"
    '';
  };
}