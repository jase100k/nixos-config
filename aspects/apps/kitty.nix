{ config, pkgs, ... }:

{
  home-manager.users.jason = {
    programs.kitty = {
      enable = true;
      font = pkgs.lib.mkForce {
        name = "JetBrainsMono Nerd Font";
        size = 11;
      };


      settings = pkgs.lib.mkForce {
        confirm_os_window_close = 0;
        enable_audio_bell = false;
        background_opacity = "0.88";
        hide_window_decorations = "yes";
      };

      extraConfig = ''
        include noctalia-theme.conf
      '';
    };
  };
}
