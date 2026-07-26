{ config, pkgs, lib, inputs, ... }:

{
  # Millennium Steam overlay
  nixpkgs.overlays = [
    inputs.millennium.overlays.default
  ];

  # Gaming packages
  environment.systemPackages = with pkgs; [
    steam-run
    steam-tui
    protontricks
    wine
    winetricks
    lutris
    heroic
    retroarch
    goverlay
    lact # Linux AMDGPU Controller (GPU monitoring, fan control, power cap)
  ];

  # Gaming optimizations (Millennium-Enhanced Steam)
  programs.steam = {
    enable = true;
    package = pkgs.millennium-steam;
    dedicatedServer.openFirewall = true;
    localNetworkGameTransfers.openFirewall = true;
    remotePlay.openFirewall = true;
    gamescopeSession.enable = true;
    extraCompatPackages = with pkgs; [
      proton-ge-bin
    ];
  };

  # Gamescope
  programs.gamescope = {
    enable = true;
    capSysNice = true;
  };

  # GameMode
  programs.gamemode.enable = true;

  # Steam hardware (controllers, Index, etc.)
  hardware.steam-hardware.enable = true;

  # AMD GPU & NTSYNC Kernel Module (Fast Wine/Proton Sync)
  boot.initrd.kernelModules = [ "amdgpu" ];
  boot.kernelModules = [ "ntsync" ];

  # Global Gaming & Wayland Environment Variables
  environment.sessionVariables = {
    STEAM_EXTRA_COMPAT_TOOLS_PATHS = "${pkgs.proton-ge-bin}";
    WINE_NTSYNC = "1";
    PROTON_ENABLE_WAYLAND = "1";
    AMD_VULKAN_ICD = "RADV";                  # High-performance Mesa RADV Vulkan driver
    RADV_PERFTEST = "gpl,nggc";              # RDNA3 GeometryShader & GPL shader pre-caching
    RADV_TEX_ANISO = "16";
  };

  # OpenGL / Vulkan
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    extraPackages = with pkgs; [
      libva-vdpau-driver
      libvdpau-va-gl
    ];
  };

  # Linux AMDGPU Controller Service (LACT)
  services.lact.enable = true;

  # Gaming firewall ports
  networking.firewall = {
    allowedTCPPorts = [ 27036 27015 ];
    allowedUDPPorts = [ 27015 27031 27032 27033 27034 27035 27036 ];
    allowedTCPPortRanges = [
      { from = 27015; to = 27030; }
    ];
    allowedUDPPortRanges = [
      { from = 27000; to = 27100; }
    ];
  };
}
