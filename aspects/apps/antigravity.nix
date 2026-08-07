{ config, pkgs, inputs, ... }:

let
  noctalia-sync-theme = pkgs.writeShellScriptBin "noctalia-sync-theme" ''
    sleep 0.2

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

    for SETTINGS_FILE in "$HOME/.config/antigravity/User/settings.json" "$HOME/.config/Code/User/settings.json" "$HOME/.config/opencode/User/settings.json"; do
      if [ -f "$SETTINGS_FILE" ]; then
        ${pkgs.jq}/bin/jq \
          --arg bg "$BG" \
          --arg fg "$FG" \
          --arg accent "$ACCENT" \
          '.["workbench.colorCustomizations"] = {
            "editor.background": $bg,
            "sideBar.background": $bg,
            "sideBar.foreground": $fg,
            "sideBarTitle.foreground": $fg,
            "sideBarSectionHeader.background": $bg,
            "activityBar.background": $bg,
            "activityBar.foreground": $accent,
            "statusBar.background": $bg,
            "statusBar.foreground": $fg,
            "titleBar.activeBackground": $bg,
            "titleBar.activeForeground": $fg,
            "tab.activeBackground": $bg,
            "tab.activeBorder": $accent,
            "tab.inactiveBackground": $bg,
            "terminal.background": $bg,
            "terminal.foreground": $fg
          }' "$SETTINGS_FILE" > "$SETTINGS_FILE.tmp" && mv "$SETTINGS_FILE.tmp" "$SETTINGS_FILE"
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
      pkgs.jq
    ];

    home.activation.syncNoctaliaTheme = config.home-manager.users.jason.lib.dag.entryAfter [ "writeBoundary" ] ''
      ${noctalia-sync-theme}/bin/noctalia-sync-theme
    '';
  };
}

