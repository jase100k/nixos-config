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
  --toolbar-bgcolor: var(--theme-sidebar-background, var(--theme-body-color, $BG)) !important;
  --toolbar-color: var(--theme-sidebar-color, var(--theme-text-color, $FG)) !important;
  --toolbar-bordercolor: var(--theme-sidebar-background, var(--theme-body-color, $BG)) !important;
  --toolbarbutton-hover-background: var(--theme-sidebar-background, var(--theme-body-color, $BG)) !important;
  --toolbarbutton-active-background: var(--theme-sidebar-background, var(--theme-body-color, $BG)) !important;
  --lwt-accent-color: var(--theme-sidebar-background, var(--theme-body-color, $BG)) !important;
  --lwt-text-color: var(--theme-sidebar-color, var(--theme-text-color, $FG)) !important;
  --toolbar-field-background-color: var(--theme-sidebar-background, var(--theme-body-color, $BG)) !important;
  --toolbar-field-focus-background-color: var(--theme-sidebar-background, var(--theme-body-color, $BG)) !important;
  --toolbar-field-color: var(--theme-sidebar-color, var(--theme-text-color, $FG)) !important;
  --toolbar-field-focus-color: var(--theme-sidebar-color, var(--theme-text-color, $FG)) !important;
  --toolbar-field-border-color: var(--theme-sidebar-background, var(--theme-body-color, $BG)) !important;
  --toolbar-field-focus-border-color: var(--theme-accent-color, $ACCENT) !important;
  --urlbar-box-background: var(--theme-sidebar-background, var(--theme-body-color, $BG)) !important;
  --urlbar-box-bgcolor: var(--theme-sidebar-background, var(--theme-body-color, $BG)) !important;
  --tab-selected-color: var(--theme-sidebar-color, var(--theme-text-color, $FG)) !important;
  --sidebar-bgcolor: var(--theme-sidebar-background, var(--theme-body-color, $BG)) !important;
  --sidebar-text-color: var(--theme-sidebar-color, var(--theme-text-color, $FG)) !important;
}
#nav-bar, #PersonalToolbar, #TabsToolbar, #sidebar-box, #sidebar, #sidebar-header, #browser-bottombox {
  background-color: var(--theme-sidebar-background, var(--theme-body-color, $BG)) !important;
  color: var(--theme-sidebar-color, var(--theme-text-color, $FG)) !important;
}
.tab-background[selected="true"] {
  background: var(--theme-sidebar-background, var(--theme-body-color, $BG)) !important;
  border-color: var(--theme-accent-color, $ACCENT) !important;
}
#urlbar, #urlbar-background, #urlbar-input-container {
  background-color: var(--theme-sidebar-background, var(--theme-body-color, $BG)) !important;
  color: var(--theme-sidebar-color, var(--theme-text-color, $FG)) !important;
}
EOF
        fi
      done
      ${pkgs.pywalfox-native}/bin/pywalfox install --profile-path "$HOME/.floorp" 2>/dev/null || true
      ${pkgs.pywalfox-native}/bin/pywalfox update 2>/dev/null || true
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
      ${pkgs.pywalfox-native}/bin/pywalfox install --profile-path "$HOME/.config/zen" 2>/dev/null || true
      ${pkgs.pywalfox-native}/bin/pywalfox update 2>/dev/null || true
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