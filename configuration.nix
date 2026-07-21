{ config, pkgs, lib, inputs, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  # CachyOS kernel overlay
  nixpkgs.overlays = [ inputs.nix-cachyos-kernel.overlays.pinned ];

  # Boot loader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Gaming kernel - CachyOS optimized kernel
  boot.kernelPackages = pkgs.cachyosKernels.linuxPackages-cachyos-latest;
  
  # Kernel parameters for gaming
  boot.kernelParams = [
    "mitigations=off"
    "preempt=full"
  ];

  # Network
  networking.hostName = "nixos-gaming";
  networking.networkmanager.enable = true;

  # Time zone
  time.timeZone = "Australia/Melbourne";

  # User account
  users.users.jason = {
    isNormalUser = true;
    description = "Jason";
    extraGroups = [ "networkmanager" "wheel" "gamemode" "video" "input" ];
    shell = pkgs.zsh;
  };

  programs.zsh.enable = true;

  # System packages
  environment.systemPackages = with pkgs; [
    # Core utilities
    wget
    curl
    git
    vim
    neovim
    htop
    btop
    tmux
    unzip
    p7zip
    
    # Gaming
    steam
    steam-run
    steam-tui
    protontricks
    wine
    winetricks
    lutris
    heroic
    retroarch
    
    # Gaming utilities
    gamemode
    mangohud
    goverlay
    gamescope
    
    # Performance monitoring
    radeontop
    
    # Audio
    pavucontrol
    
    # Graphics
    vlc
    mpv
    
    # Browsers
    brave
    floorp-bin
    
    # Development (optional)
    gcc
    gnumake
    cmake
    
    # Misc
    fastfetch
    screenfetch

    # Cursor themes
    xcursor-themes
    bibata-cursors
    
    # AI
    opencode
  ];

  # Enable Flakes + allow unfree packages
  nixpkgs.config.allowUnfree = true;
  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    auto-optimise-store = true;
  };

  # Garbage collection
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };

  # Gaming optimizations
  programs.steam = {
    enable = true;
    dedicatedServer.openFirewall = true;
    localNetworkGameTransfers.openFirewall = true;
  };

  # GameMode
  programs.gamemode.enable = true;

  # AMD GPU
  boot.initrd.kernelModules = [ "amdgpu" ];

  # OpenGL / Vulkan
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    extraPackages = with pkgs; [
      libva-vdpau-driver
      libvdpau-va-gl
    ];
  };

  # Audio (PipeWire - recommended for gaming)
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };

  # Disable PulseAudio (using PipeWire instead)
  services.pulseaudio.enable = false;

  # X11 / Display
  services.xserver = {
    enable = true;
    xkb.layout = "us";
    exportConfiguration = true;
  };

  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;


  # Flatpak support (for some games)
  services.flatpak.enable = true;
  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };

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

  # Power management
  powerManagement = {
    enable = true;
    cpuFreqGovernor = "performance";
  };

  # ZRAM for better memory management
  zramSwap = {
    enable = true;
    memoryPercent = 50;
  };

  # System-wide environment variables
  environment.sessionVariables = {
    QT_QPA_PLATFORM = "wayland";
    MOZ_ENABLE_WAYLAND = "1";
    EDITOR = "nvim";
    VISUAL = "nvim";
    GAMEMODE_RUN = "1";
    MANGOHUD = "1";
  };

  # Enable nix-ld for running unpatched binaries
  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
    stdenv.cc.cc
    zlib
    fuse3
    alsa-lib
    at-spi2-core
    cups
    libdrm
    libGL
    libxkbcommon
    nspr
    nss
    libX11
    libXcursor
    libXi
    libXrandr
    libXrender
    libXxf86vm
    libxcb
  ];

  # Don't change this value
  system.stateVersion = "26.05";
}
