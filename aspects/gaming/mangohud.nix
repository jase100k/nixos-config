{ config, pkgs, ... }:

{
  home-manager.users.jason = {
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
  };
}
