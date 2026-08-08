{ config, pkgs, inputs, ... }:

{
  home-manager.users.jason = {
    home.packages = [
      inputs.zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.default
    ];
    home.activation.zenBrowserTheme = config.home-manager.users.jason.lib.dag.entryAfter [ "writeBoundary" ] ''
      ZEN_APPLY="$HOME/.local/state/noctalia/community-templates/zen-browser/apply.sh"
      if [ -f "$ZEN_APPLY" ]; then
        bash "$ZEN_APPLY" || true
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

          USER_CHROME="$profile/chrome/userChrome.css"
          IMPORT_LINE="@import \"$HOME/.cache/noctalia/zen-browser/zen-userChrome.css\";"
          if ! grep -q "zen-userChrome.css" "$USER_CHROME" 2>/dev/null; then
            echo "$IMPORT_LINE" | cat - "$USER_CHROME" > "$USER_CHROME.tmp" 2>/dev/null || echo "$IMPORT_LINE" > "$USER_CHROME.tmp"
            mv "$USER_CHROME.tmp" "$USER_CHROME"
          fi
        fi
      done
    '';
  };
}




