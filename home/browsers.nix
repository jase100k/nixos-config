{ pkgs, ... }:

{
  programs.firefox = {
    enable = true;
    configPath = ".mozilla/firefox";
    profiles.default = {
      settings = {
        "media.ffmpeg.vaapi.enabled" = true;
        "gfx.webrender.all" = true;
        "layers.acceleration.force-enabled" = true;
      };
    };
  };

  home.activation.floorpChrome = ''
    find ~/.floorp -mindepth 1 -maxdepth 1 -type d -name '*.default' | while read profile; do
      mkdir -p "$profile/chrome"
      cat > "$profile/chrome/userChrome.css" << 'UACHROME'
    @media (prefers-color-scheme: dark) {
      :root {
        --uc-theme-bg: #0b1019;
        --uc-theme-bg-secondary: #121820;
        --uc-theme-fg: #bfbdb6;
        --uc-theme-accent: #ffcc66;
        --uc-theme-accent2: #39bae6;
        --uc-theme-accent3: #ffb454;
        --uc-theme-border: #1f2733;
        --uc-theme-highlight: #273747;
      }
    }

    #TabsToolbar {
      background: var(--uc-theme-bg) !important;
    }

    .tab-background {
      background: var(--uc-theme-bg-secondary) !important;
      border: 1px solid var(--uc-theme-border) !important;
      border-radius: 8px !important;
      margin: 2px 4px !important;
    }

    .tab-background[selected="true"] {
      background: var(--uc-theme-highlight) !important;
      border-color: var(--uc-theme-accent) !important;
    }

    .tab-label {
      color: var(--uc-theme-fg) !important;
    }

    #nav-bar {
      background: var(--uc-theme-bg) !important;
      border-bottom: 1px solid var(--uc-theme-border) !important;
    }

    #urlbar {
      background: var(--uc-theme-bg-secondary) !important;
      border: 1px solid var(--uc-theme-border) !important;
      border-radius: 8px !important;
      color: var(--uc-theme-fg) !important;
    }

    #urlbar[focused="true"] {
      border-color: var(--uc-theme-accent) !important;
    }

    .sidebar-box {
      background: var(--uc-theme-bg) !important;
    }

    #sidebar-header {
      background: var(--uc-theme-bg-secondary) !important;
    }
    UACHROME
    done
  '';
}
