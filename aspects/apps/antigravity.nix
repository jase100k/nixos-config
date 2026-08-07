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

    for SETTINGS_FILE in "$HOME/.antigravity-ide/User/settings.json" "$HOME/.config/antigravity/User/settings.json" "$HOME/.config/Code/User/settings.json" "$HOME/.config/opencode/User/settings.json"; do
      SETTINGS_DIR=$(dirname "$SETTINGS_FILE")
      if [ -d "$SETTINGS_DIR" ]; then
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


      fi
    done
  '';

  noctalia-theme-watcher = pkgs.writeShellScriptBin "noctalia-theme-watcher" ''
    ${noctalia-sync-theme}/bin/noctalia-sync-theme

    THEME_DIR="$HOME/.config/alacritty/themes"
    mkdir -p "$THEME_DIR"

    ${pkgs.inotify-tools}/bin/inotifywait -m -e close_write,moved_to,create "$THEME_DIR" | while read -r dir events file; do
      if [ "$file" = "noctalia.toml" ]; then
        ${noctalia-sync-theme}/bin/noctalia-sync-theme
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
      noctalia-sync-theme
      noctalia-theme-watcher
      pkgs.jq
      pkgs.inotify-tools
    ];

    systemd.user.services.noctalia-antigravity-sync = {
      Unit = {
        Description = "Noctalia Theme Sync Service for Antigravity & VS Code";
        After = [ "graphical-session.target" ];
      };
      Service = {
        ExecStart = "${noctalia-theme-watcher}/bin/noctalia-theme-watcher";
        Restart = "always";
        RestartSec = 3;
      };
      Install = {
        WantedBy = [ "default.target" ];
      };
    };

    home.activation.syncNoctaliaTheme = config.home-manager.users.jason.lib.dag.entryAfter [ "writeBoundary" ] ''
      ${noctalia-sync-theme}/bin/noctalia-sync-theme
    '';
  };
}




