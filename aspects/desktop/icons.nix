{ config, pkgs, ... }:

{
  # Active icon theme for the desktop (resolves dock/launcher app icons like vscode)
  environment.systemPackages = with pkgs; [ papirus-icon-theme ];

  home-manager.users.jason = {
    # Force GTK4 to use Papirus-Dark as the active icon theme.
    # The gtk.iconTheme API above does not reliably write gtk-icon-theme-name
    # into gtk-4.0/settings.ini, so write the file directly.
    xdg.configFile."gtk-4.0/settings.ini".text = ''
      [Settings]
      gtk-cursor-theme-name=Bibata-Modern-Classic
      gtk-cursor-theme-size=24
      gtk-font-name=Noto Sans 12
      gtk-theme-name=adw-gtk3
      gtk-icon-theme-name=Papirus-Dark
    '';
  };
}
