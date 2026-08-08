{ config, pkgs, ... }:

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
    '';
  };
}