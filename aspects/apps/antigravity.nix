{ config, pkgs, inputs, ... }:

let
  noctalia-sync-theme = pkgs.writeShellScriptBin "noctalia-sync-theme" ''
    THEME_FILE="$HOME/.config/alacritty/themes/noctalia.toml"
    if [ ! -f "$THEME_FILE" ]; then
      exit 0
    fi

    BG=$(grep -E '^\s*background\s*=' "$THEME_FILE" | head -n 1 | cut -d "'" -f 2)
    FG=$(grep -E '^\s*foreground\s*=' "$THEME_FILE" | head -n 1 | cut -d "'" -f 2)
    ACCENT=$(grep -E '^\s*blue\s*=' "$THEME_FILE" | head -n 1 | cut -d "'" -f 2)

    BG=''${BG:-#1e1010}
    FG=''${FG:-#f8dcdb}
    ACCENT=''${ACCENT:-$FG}

    SETTINGS_FILE="$HOME/.antigravity-ide/User/settings.json"
    SETTINGS_DIR=$(dirname "$SETTINGS_FILE")
    mkdir -p "$SETTINGS_DIR"
    if [ ! -f "$SETTINGS_FILE" ] || ! ${pkgs.jq}/bin/jq . "$SETTINGS_FILE" >/dev/null 2>&1; then
      echo '{"workbench.colorCustomizations":{}}' > "$SETTINGS_FILE"
    fi

    ${pkgs.jq}/bin/jq \
      --arg bg "$BG" \
      --arg fg "$FG" \
      --arg accent "$ACCENT" \
      '.["workbench.colorTheme"] = "Default Dark Modern" |
       .["workbench.colorCustomizations"] = {
        "editor.background": $bg,
        "editor.foreground": $fg,
        "sideBar.background": $bg,
        "sideBar.foreground": $fg,
        "sideBarTitle.foreground": $fg,
        "sideBarSectionHeader.background": $bg,
        "activityBar.background": $bg,
        "activityBar.foreground": $accent,
        "activityBar.activeBackground": $bg,
        "statusBar.background": $bg,
        "statusBar.foreground": $fg,
        "titleBar.activeBackground": $bg,
        "titleBar.activeForeground": $fg,
        "tab.activeBackground": $bg,
        "tab.activeForeground": $fg,
        "tab.activeBorder": $accent,
        "tab.inactiveBackground": $bg,
        "tab.inactiveForeground": $fg,
        "panel.background": $bg,
        "panel.border": $accent,
        "editorGroupHeader.tabsBackground": $bg,
        "commandCenter.background": $bg,
        "commandCenter.foreground": $fg,
        "commandCenter.border": $accent,
        "terminal.background": $bg,
        "terminal.foreground": $fg
      }' "$SETTINGS_FILE" > "$SETTINGS_FILE.tmp" && cat "$SETTINGS_FILE.tmp" > "$SETTINGS_FILE" && rm -f "$SETTINGS_FILE.tmp"

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
  --lwt-toolbar-field-background-color: $BG !important;
  --lwt-toolbar-field-focus-background-color: $BG !important;
  --lwt-toolbar-field-color: $FG !important;
  --lwt-toolbar-field-focus-color: $FG !important;
  --urlbar-box-background: $BG !important;
  --urlbar-box-bgcolor: $BG !important;
  --urlbar-open-background: $BG !important;
  --urlbar-box-focus-background: $BG !important;
  --urlbarView-highlight-background: $BG !important;

  --tab-selected-color: $FG !important;
  --sidebar-bgcolor: $BG !important;
  --sidebar-text-color: $FG !important;
  --sidebar-border-color: $BG !important;
  --bookmark-text-color: $FG !important;
  --chrome-content-separator-color: $BG !important;

  --panel-background: $BG !important;
  --panel-color: $FG !important;
  --panel-border-color: $BG !important;
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
  '';

in
{
  home-manager.users.jason = {
    home.packages = [
      inputs.antigravity-nix.packages.${pkgs.stdenv.hostPlatform.system}.default
      inputs.antigravity-nix.packages.${pkgs.stdenv.hostPlatform.system}.google-antigravity-ide
      inputs.antigravity-nix.packages.${pkgs.stdenv.hostPlatform.system}.google-antigravity-cli
      pkgs.jq
    ];
  };
}





