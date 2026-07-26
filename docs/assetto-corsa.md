# Assetto Corsa + Content Manager + Custom Shaders Patch on NixOS

This document details the complete configuration, fixes, and Home Manager integration for running **Assetto Corsa**, **Content Manager (CM)**, and **Custom Shaders Patch (CSP)** under Linux & NixOS.

---

## 1. Overview of Fixes Required

Assetto Corsa and Content Manager rely on Windows `.NET Framework 4.8`, WPF rendering, and Steam Account detection. Under Linux/Wine/Proton, the following steps are required:

1. **Executable Swap (Content Manager Launcher)**:
   Steam launches `AssettoCorsa.exe`. Replacing `AssettoCorsa.exe` with `Content Manager.exe` causes Steam to launch Content Manager directly when clicking **PLAY**.
2. **`loginusers.vdf` Symlink**:
   Content Manager requires Steam's `loginusers.vdf` file inside the Wine prefix to detect your Steam account:
   `~/.local/share/Steam/steamapps/compatdata/244210/pfx/drive_c/Program Files (x86)/Steam/config/loginusers.vdf`
3. **Custom Shaders Patch (CSP) `dwrite.dll` Override**:
   CSP hooks into DirectX via `dwrite.dll`. Steam Launch options or `protonfixes` must override `dwrite.dll = native, builtin`.
4. **`STEAM_EXTRA_COMPAT_TOOLS_PATHS` System-wide Export**:
   NixOS exposes `pkgs.proton-ge-bin` inside Steam, but `protontricks` running in user shells needs `STEAM_EXTRA_COMPAT_TOOLS_PATHS = "${pkgs.proton-ge-bin}"` set in `environment.sessionVariables`.
5. **Content Manager Black Window Fix**:
   In Content Manager $\rightarrow$ **Settings** $\rightarrow$ **Content Manager** $\rightarrow$ **Appearance**, check **"Disable windows transparency"**.

---

## 2. Home Manager Integration (`home/gaming.nix`)

The configuration in `home/gaming.nix` includes:
- **`setup-assetto-corsa` CLI Tool**: Automatically checks and performs the executable swap and prefix symlink.
- **Home Manager Activation Hook**: Automatically runs during `nixos-rebuild switch` / `update` to ensure `AssettoCorsa.exe` is Content Manager and `loginusers.vdf` is symlinked.

### Running Manually
You can re-run the setup anytime by running:
```bash
setup-assetto-corsa
```

---

## 3. Steam Launch Options
In Steam $\rightarrow$ **Assetto Corsa Properties** $\rightarrow$ **General** $\rightarrow$ **Launch Options**:

```bash
PROTON_LOG=1 PROTON_ENABLE_WAYLAND=1 WINEDLLOVERRIDES="dwrite=n,b" mangohud gamemoderun %command%
```
