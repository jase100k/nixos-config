{ config, pkgs, inputs, ... }:

{
  home-manager.users.jason = {
    home.packages = [
      inputs.antigravity-nix.packages.${pkgs.stdenv.hostPlatform.system}.default
      inputs.antigravity-nix.packages.${pkgs.stdenv.hostPlatform.system}.google-antigravity-ide
      inputs.antigravity-nix.packages.${pkgs.stdenv.hostPlatform.system}.google-antigravity-cli
    ];

    # Noctalia native user template for Antigravity & VS Code settings
    xdg.configFile."noctalia/templates/antigravity.json.tpl".text = ''
      {
        "workbench.colorCustomizations": {
          "editor.background": "{{colors.surface.default.hex}}",
          "editor.foreground": "{{colors.on_surface.default.hex}}",
          "sideBar.background": "{{colors.surface.default.hex}}",
          "sideBar.foreground": "{{colors.on_surface.default.hex}}",
          "sideBarTitle.foreground": "{{colors.on_surface.default.hex}}",
          "sideBarSectionHeader.background": "{{colors.surface.default.hex}}",
          "activityBar.background": "{{colors.surface.default.hex}}",
          "activityBar.foreground": "{{colors.primary.default.hex}}",
          "statusBar.background": "{{colors.surface.default.hex}}",
          "statusBar.foreground": "{{colors.on_surface.default.hex}}",
          "titleBar.activeBackground": "{{colors.surface.default.hex}}",
          "titleBar.activeForeground": "{{colors.on_surface.default.hex}}",
          "tab.activeBackground": "{{colors.surface.default.hex}}",
          "tab.activeBorder": "{{colors.primary.default.hex}}",
          "tab.inactiveBackground": "{{colors.surface.default.hex}}",
          "panel.background": "{{colors.surface.default.hex}}",
          "editorGroupHeader.tabsBackground": "{{colors.surface.default.hex}}",
          "terminal.background": "{{colors.surface.default.hex}}",
          "terminal.foreground": "{{colors.on_surface.default.hex}}"
        },
        "python.languageServer": "Default"
      }
    '';

    xdg.configFile."noctalia/user-templates.toml".text = ''
      [templates.antigravity]
      input_path = "~/.config/noctalia/templates/antigravity.json.tpl"
      output_path = "~/.config/antigravity/User/settings.json"

      [templates.vscode]
      input_path = "~/.config/noctalia/templates/antigravity.json.tpl"
      output_path = "~/.config/Code/User/settings.json"
    '';
  };
}



