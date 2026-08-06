{ config, pkgs, lib, inputs, ... }:

{
  # CachyOS kernel & upstream fix overlays
  nixpkgs.overlays = [
    inputs.nix-cachyos-kernel.overlays.pinned
  ];

  # Boot loader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Gaming kernel - CachyOS latest pre-built kernel (BORE + NTSYNC + Cachix binary hit)
  boot.kernelPackages = pkgs.cachyosKernels.linuxPackages-cachyos-latest;

  # Kernel parameters for gaming (CachyOS + AMD Ryzen 5700X3D + RDNA3)
  boot.kernelParams = [
    "mitigations=off"                 # Security trade-off for gaming performance
    "amd_pstate=active"               # AMD P-State EPP driver for Ryzen 5700X3D 3D V-Cache
    "amdgpu.ppfeaturemask=0xffffffff" # Unlock full AMD GPU power management & tuning
    "transparent_hugepage=madvise"    # 2MB Hugepages for game heap allocators (jemalloc/mimalloc)
  ];

  # CachyOS Sysctl Kernel Optimizations for Low Latency Gaming
  boot.kernel.sysctl = {
    "vm.max_map_count" = 2147483642;          # Needed for UE5 / StarCitizen / AAA games
    "vm.swappiness" = 10;                     # Avoid premature RAM swapping
    "vm.dirty_background_ratio" = 5;          # Smooth background I/O
    "vm.dirty_ratio" = 10;
    "net.core.default_qdisc" = "fq_codel";    # CachyOS low-latency queueing
    "net.ipv4.tcp_congestion_control" = "bbr"; # BBR network congestion control
  };

  # Network
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
    extraGroups = [ "networkmanager" "wheel" "gamemode" "video" "input" "libvirtd" "dialout" "uinput" ];
    shell = pkgs.zsh;
  };

  # Serial & Microcontroller permissions (ESP32 / Pico / WebSerial)
  services.udev.extraRules = ''
    KERNEL=="ttyACM*", MODE="0666"
    KERNEL=="ttyUSB*", MODE="0666"

    # Pico FIDO / Pico Key hidraw access
    KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{idVendor}=="2e8a", ATTRS{idProduct}=="10fd", TAG+="uaccess", GROUP="users", MODE="0660"
    KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{idVendor}=="2e8a", ATTRS{idProduct}=="10fe", TAG+="uaccess", GROUP="users", MODE="0660"
  '';

  # SmartCard / CCID daemon for security keys (Pico FIDO / YubiKey)
  services.pcscd.enable = true;


  programs.zsh.enable = true;

  # Fonts
  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
    nerd-fonts.fira-code
    inter
    roboto
  ];

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

    # Performance monitoring
    radeontop

    # Audio
    pavucontrol

    # Graphics & Media
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

    # Development
    gcc
    gnumake
    cmake

    # NFS utilities
    nfs-utils

    # Misc
    fastfetch

    # GTK / Qt & Browser Theming (Noctalia integration)
    adw-gtk3
    nwg-look
    vesktop
    pywalfox-native

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
    extra-substituters = [
      "https://noctalia.cachix.org"
      "https://cachyos.cachix.org"
    ];
    extra-trusted-public-keys = [
      "noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4="
      "cachyos.cachix.org-1:95b2C3UaaPJUGlGLM22sm6lR4n9wVUqBLVn86uu03j8="
    ];
  };

  # Garbage collection
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };

  # Audio (PipeWire - recommended for gaming)
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
    extraConfig.pipewire."92-low-latency" = {
      "context.properties" = {
        "default.clock.rate" = 48000;
        "default.clock.quantum" = 64;
        "default.clock.min-quantum" = 32;
        "default.clock.max-quantum" = 512;
      };
    };
  };

  # Disable PulseAudio (using PipeWire instead)
  services.pulseaudio.enable = false;


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

  # Power management
  powerManagement = {
    enable = true;
    cpuFreqGovernor = "schedutil";
  };

  # ZRAM for better memory management
  zramSwap = {
    enable = true;
    algorithm = "zstd";
    memoryPercent = 50;
  };

  # System-wide environment variables
  environment.sessionVariables = {
    MOZ_ENABLE_WAYLAND = "1";
    EDITOR = "nvim";
    VISUAL = "nvim";
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
}
