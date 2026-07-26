# NixOS Gaming Configuration

![NixOS](https://img.shields.io/badge/NixOS-26.05-blue?logo=nixos&logoColor=white)
![Flakes](https://img.shields.io/badge/Nix_Flakes-Enabled-blueviolet?logo=nix&logoColor=white)
![Kernel](https://img.shields.io/badge/Kernel-CachyOS_BORE-brightgreen?logo=linux&logoColor=white)
![Wayland](https://img.shields.io/badge/Wayland-MangoWM_%7C_Niri_%7C_Plasma-orange?logo=wayland&logoColor=white)

A modular, reproducible, high-performance NixOS configuration optimized for gaming, low-latency audio/display, and modern Wayland desktop environments.

---

## 🌟 Highlights

- **CachyOS Linux Kernel**: Pre-built CachyOS kernel with BORE CPU scheduler, NTSYNC fast Wine/Proton synchronization, and optimized sysctl tweaks (`vm.max_map_count`, BBR TCP congestion control, Madvise Hugepages).
- **AMD Ryzen 5700X3D + RDNA3 Optimization**: Customized kernel parameters (`amd_pstate=active`, `amdgpu.ppfeaturemask`, RADV GPL & NGGC shader pre-caching).
- **Gaming Suite**:
  - **Millennium Steam**: Modded Steam client supporting custom themes and plugins.
  - **LACT (Linux AMDGPU Controller)**: GPU monitoring, power limit controls, and custom fan curves.
  - **Gamescope & GameMode**: Compositor isolation and real-time scheduling priority.
  - **Proton-GE & NTSYNC**: Automated Proton-GE integration and zero-overhead synchronization.
- **Wayland Desktop Experience**:
  - **MangoWM**: Custom Wayland tiling compositor session.
  - **Niri**: Dynamic scrollable tiling Wayland compositor.
  - **KDE Plasma 6**: Fully declarative desktop setup via `plasma-manager`.
  - **Noctalia v5**: Modern desktop shell (status bar, launcher, notifications, dynamic pywalfox browser theming).
- **Automated Fixes & Utilities**:
  - `gaming-assetocorsa-fix`: Custom sub-flake & Home Manager service (`setup-assetto-corsa`) that auto-downloads Content Manager, sets up executable replacement, and creates Wine prefix symlinks for Steam integration.

---

## 📁 Repository Structure

```text
.
├── flake.nix                 # Flake entrypoint & host definitions
├── flake.lock                # Pinned dependency revisions
├── hosts/                    # Machine-specific configurations
│   └── nixos-gaming/
│       ├── default.nix       # Main host config (hostname, state version, module imports)
│       └── hardware-configuration.nix # Hardware scan output
├── modules/                  # Reusable system & home modules
│   ├── nixos/                # System-level NixOS modules
│   │   ├── default.nix       # Aggregates system modules
│   │   ├── system.nix        # Kernel, bootloader, sysctl, audio, user setup
│   │   ├── desktop.nix       # SDDM, Plasma 6, MangoWM, Niri, Noctalia shell, Flatpak
│   │   └── gaming.nix        # Steam (Millennium), Gamescope, GameMode, LACT, RADV env
│   └── home/                 # User-level Home Manager modules (user: jason)
│       ├── default.nix       # Aggregates user modules and home packages
│       ├── browsers.nix      # Floorp, Brave, Pywalfox theming
│       ├── editors.nix       # Development editors & IDE tools
│       ├── gaming.nix        # User gaming tweaks & Assetto Corsa fix activation
│       ├── git.nix           # Git user profile
│       ├── messaging.nix     # Vesktop / Discord configuration
│       ├── shell.nix         # Zsh configuration & Starship prompt
│       ├── terminal.nix      # Terminal emulator settings
│       ├── millennium-config.json # Steam Millennium theme/plugin config
│       ├── desktop/          # User desktop shell configuration
│       │   ├── default.nix
│       │   ├── noctalia.nix  # Noctalia v5 shell configuration
│       │   └── plasma.nix    # Declarative KDE Plasma settings
│       └── wm/               # Wayland compositor configs
│           ├── default.nix
│           ├── fuzzel.nix    # Fuzzel application launcher
│           ├── mango.nix     # MangoWM keybindings and layout
│           └── niri.nix      # Niri scrollable tiler config
├── pkgs/                     # Custom in-repo flakes and packages
│   └── gaming-assetocorsa-fix/
│       └── flake.nix         # Flake providing setup-assetto-corsa & HM service
└── docs/                     # Detailed guides and technical documentation
    └── assetto-corsa.md      # Setup guide for Assetto Corsa + Content Manager + CSP
```

---

## ⚡ Setup & Usage

### 1. Build and Rebuild System

To switch to the `nixos-gaming` configuration:

```bash
# Rebuild and apply configuration immediately
sudo nixos-rebuild switch --flake .#nixos-gaming

# Test build without applying
nixos-rebuild build --flake .#nixos-gaming
```

### 2. Updating Dependencies

Update flake inputs (such as Nixpkgs, CachyOS Kernel, Niri, Noctalia):

```bash
nix flake update
```

---

## 🎮 Special Features & Fixes

### Assetto Corsa + Content Manager + Custom Shaders Patch

Included in `pkgs/gaming-assetocorsa-fix`, this setup automates the installation and configuration of **Content Manager (CM)** and **Custom Shaders Patch (CSP)** for Assetto Corsa under Wine/Proton.

- **Auto-Installation**: Automatically downloads the latest Content Manager release from `acstuff.ru` if not present.
- **Executable Swap**: Replaces `AssettoCorsa.exe` with Content Manager so Steam launches CM natively when clicking **PLAY**.
- **Wine Prefix Symlink**: Creates required `loginusers.vdf` symlink inside the Wine prefix for Steam login authentication.

To trigger setup manually:
```bash
setup-assetto-corsa
```

Refer to [docs/assetto-corsa.md](docs/assetto-corsa.md) for detailed setup steps and launch options.

---

## 🛠️ Binary Caches

To ensure fast builds without compiling kernels or custom desktop components from source, the flake is configured to use the following substituters:

- `https://cachyos.cachix.org`
- `https://noctalia.cachix.org`

---

## 📄 License

Distributed under the [MIT License](LICENSE).
