{ config, pkgs, lib, inputs, ... }:

{
  # CachyOS kernel overlay + Millennium Steam overlay
  nixpkgs.overlays = [
    inputs.nix-cachyos-kernel.overlays.pinned
    inputs.millennium.overlays.default
  ];

  # Boot loader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Gaming kernel - CachyOS optimized kernel
  boot.kernelPackages = pkgs.cachyosKernels.linuxPackages-cachyos-latest;
  
  # Kernel parameters for gaming
  boot.kernelParams = [
    "mitigations=off" # Security trade-off for gaming performance
  ];

  # Network
  networking.hostName = "nixos-gaming";
  networking.networkmanager.enable = true;

  # Bluetooth
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;

  # Virtualisation (KVM/QEMU)
  virtualisation.libvirtd.enable = true;
  programs.virt-manager.enable = true;
  virtualisation.spiceUSBRedirection.enable = true;

  # Time zone
  time.timeZone = "Australia/Melbourne";

  # User account
  users.users.jason = {
    isNormalUser = true;
    description = "Jason";
    extraGroups = [ "networkmanager" "wheel" "gamemode" "video" "input" "libvirtd" ];
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
    htop
    btop
    tmux
    unzip
    p7zip
    usbutils
    
    # Gaming
    steam-run
    steam-tui
    protontricks
    wine
    winetricks
    lutris
    heroic
    retroarch
    
    # Gaming utilities
    goverlay
    
    # Performance monitoring
    radeontop
    
    # Audio
    pavucontrol
    
    # Graphics
    vlc
    mpv

    # Wayland utilities
    wlr-randr

    # Screenshot tools
    grim
    slurp
    wl-clipboard
    xclip
    satty
    wayfreeze
    

    
    # Development (optional)
    gcc
    gnumake
    cmake
    
    # Misc
    fastfetch

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
    cores = 16;
    trusted-users = [ "root" "jason" ];
    extra-substituters = [ "https://noctalia.cachix.org" ];
    extra-trusted-public-keys = [ "noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4=" ];
  };

  # Garbage collection
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };

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
  services.displayManager.sessionPackages = [ inputs.niri.packages.x86_64-linux.niri-stable ];
  services.desktopManager.plasma6.enable = true;

  # MangoWM - Wayland compositor (available as SDDM session)
  programs.mango = {
    enable = true;
    addLoginEntry = true;
  };

  # Noctalia v5 - Desktop shell for MangoWM and Niri
  programs.noctalia = {
    enable = true;
    recommendedServices.enable = true;
  };

  # Override plasma6's mkDefault so SDDM shows the session selector
  # (lets user choose between Plasma and MangoWM at login)
  services.displayManager.defaultSession = lib.mkForce null;
  services.flatpak.enable = true;

  # Printing (CUPS)
  services.printing = {
    enable = true;
    extraConf = ''
      <Location />
        Order deny,allow
        Deny from all
        Allow from 127.0.0.1
        Allow from 192.168.11.*
      </Location>
    '';
  };
  hardware.printers.ensurePrinters = [
    {
      name = "Canon";
      deviceUri = "ipp://192.168.11.220/ipp/print";
      model = "drv:///cupsfilters.drv/pwgrast.ppd";
      description = "Canon Network Printer";
    }
  ];
  hardware.printers.ensureDefaultPrinter = "Canon";

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
    cpuFreqGovernor = "schedutil";
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
    RADV_TEX_ANISO = "16";
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
