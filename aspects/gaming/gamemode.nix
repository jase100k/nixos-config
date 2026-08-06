{ config, pkgs, ... }:

{
  programs.gamemode.enable = true;

  home-manager.users.jason = {
    xdg.configFile."gamemode.ini" = {
      text = ''
        [general]
        reaper_thread_count=4
        renice=4

        [gpu]
        apply_gpu_optimisations=accept-responsibility
        gpu_device=0
        amd_performance_level=high

        [cpu]
        pin_current_process=1
        restrict_governor_performance=1
      '';
    };
  };
}
