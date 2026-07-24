{ pkgs, ... }:

{
  home.activation.floorpTheme = ''
    profile="$(find ~/.floorp -mindepth 1 -maxdepth 1 -type d -name '*.default' | head -1)"
    if [ -n "$profile" ]; then
      mkdir -p "$profile/chrome"

      cat > "$profile/chrome/userChrome.css" << 'UACHROME'
:root {
  --toolbar-bgcolor: #0b1019 !important;
  --toolbar-color: #bfbdb6 !important;
  --toolbar-bordercolor: #1f2733 !important;
  --toolbarbutton-hover-background: #273747 !important;
  --toolbarbutton-active-background: #273747 !important;
  --lwt-accent-color: #0b1019 !important;
  --lwt-text-color: #bfbdb6 !important;
  --tab-selected-color: #bfbdb6 !important;
  --toolbar-field-background-color: #121820 !important;
  --toolbar-field-color: #bfbdb6 !important;
  --toolbar-field-border-color: #1f2733 !important;
  --toolbar-field-focus-border-color: #ffcc66 !important;
  --sidebar-bgcolor: #0b1019 !important;
  --sidebar-text-color: #bfbdb6 !important;
  --sidebar-border-color: #1f2733 !important;
  --bookmark-text-color: #bfbdb6 !important;
  --chrome-content-separator-color: #1f2733 !important;
}

#nav-bar,
#PersonalToolbar,
#TabsToolbar,
#sidebar-box,
#browser-bottombox,
toolbar[type="menubar"] {
  background-color: #0b1019 !important;
  color: #bfbdb6 !important;
  border-color: #1f2733 !important;
}

#PersonalToolbar .toolbarbutton-text,
#PersonalToolbar .bookmark-item .toolbarbutton-icon,
#PersonalToolbar toolbarbutton {
  color: #bfbdb6 !important;
  fill: #bfbdb6 !important;
}

#sidebar-box {
  background: #0b1019 !important;
}

#sidebar-header {
  background: #121820 !important;
  color: #bfbdb6 !important;
}

#sidebar {
  background: #0b1019 !important;
  color: #bfbdb6 !important;
}

.tabbrowser-tab {
  color: #bfbdb6 !important;
}

.tab-background {
  background: #121820 !important;
  border: 1px solid #1f2733 !important;
  border-radius: 8px !important;
  margin: 2px 4px !important;
}

.tab-background[selected="true"] {
  background: #273747 !important;
  border-color: #ffcc66 !important;
}

#urlbar {
  background: #121820 !important;
  border: 1px solid #1f2733 !important;
  border-radius: 8px !important;
  color: #bfbdb6 !important;
}

#urlbar[focused="true"] {
  border-color: #ffcc66 !important;
}

#status-bar {
  background: #0b1019 !important;
  color: #bfbdb6 !important;
}

#back-button > .toolbarbutton-icon,
#forward-button > .toolbarbutton-icon {
  fill: #bfbdb6 !important;
}
UACHROME

      cat > "$profile/chrome/userContent.css" << 'UACSS'
@-moz-document url-prefix(about:), url-prefix(moz-extension://) {
  body, html {
    background-color: #0b1019 !important;
    color: #bfbdb6 !important;
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
