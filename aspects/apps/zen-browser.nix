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
    '';
  };
}


