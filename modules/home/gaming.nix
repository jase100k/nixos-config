{ pkgs, lib, ... }:

{
  # Enable Assetto Corsa & Content Manager setup fix flake module (Disabled)
  # services.assetto-corsa-fix.enable = true;

  home.packages = with pkgs; [
    (callPackage ../../pkgs/setup-assetto-corsa.nix {}) # On-demand CLI setup tool for Assetto Corsa & Content Manager
    (callPackage ../../pkgs/setup-bakkesmod.nix {})     # On-demand CLI setup tool for Rocket League & BakkesMod
    protonplus     # GTK4 GUI manager for downloading custom Proton builds (GE-Proton, Wine-GE, etc.)
    protontricks   # Winetricks & DLL helper for Steam games
  ];

  programs.mangohud = {
    enable = true;
    settings = {
      fps = true;
      cpu_temp = true;
      gpu_temp = true;
      ram = true;
      vram = true;
      cpu_power = true;
      gpu_power = true;
      frame_timing = true;
      graph_temp = true;
      font_size = 24;
      cpu_color = "2E8B57";
      gpu_color = "5F9EA0";
      vram_color = "B8860B";
      ram_color = "B22222";
    };
  };

  xdg.configFile."gamescope/gamescope.env" = {
    text = ''
      # Gamescope environment
      MANGOHUD=1
    '';
  };

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

  xdg.configFile."millennium/config.json" = {
    source = ./millennium-config.json;
    force = true;
  };
}
