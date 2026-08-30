{ config, pkgs, lib, ... }:

{
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

  hardware.steam-hardware.enable = true;

  environment.systemPackages = with pkgs; [
    steam-run
    steam-tui
    protontricks
    protonplus
    wine
    winetricks
    lutris
    heroic
    goverlay
    lact
    evtest
    jstest-gtk
    oversteer
    moonlight-qt
  ];

  services.udev.extraRules = ''
    SUBSYSTEM=="hidraw", ATTRS{idVendor}=="ddfd", MODE="0666", TAG+="uaccess"
    SUBSYSTEM=="usb", ATTRS{idVendor}=="ddfd", MODE="0666", TAG+="uaccess"
    SUBSYSTEM=="input", ATTRS{idVendor}=="ddfd", ENV{ID_INPUT_JOYSTICK}="1", ENV{ID_INPUT_ACCELEROMETER}="0", MODE="0666", TAG+="uaccess"
    KERNEL=="event*", ATTRS{idVendor}=="ddfd", ENV{ID_INPUT_JOYSTICK}="1", ENV{ID_INPUT_ACCELEROMETER}="0", MODE="0666", TAG+="uaccess"
    KERNEL=="js*", ATTRS{idVendor}=="ddfd", ENV{ID_INPUT_JOYSTICK}="1", ENV{ID_INPUT_ACCELEROMETER}="0", MODE="0666", TAG+="uaccess"
  '';

  environment.sessionVariables = {
    STEAM_EXTRA_COMPAT_TOOLS_PATHS = "${pkgs.proton-ge-bin}";
    WINE_NTSYNC = "1";
    PROTON_ENABLE_WAYLAND = "1";
    AMD_VULKAN_ICD = "RADV";
    RADV_PERFTEST = "gpl,nggc";
    RADV_TEX_ANISO = "16";
  };

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    extraPackages = with pkgs; [
      libva-vdpau-driver
      libvdpau-va-gl
    ];
  };

  services.lact.enable = true;

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

  services.sunshine = {
    enable = true;
    autoStart = true;
    capSysAdmin = true;
    openFirewall = true;
  };

  hardware.uinput.enable = true;
}
