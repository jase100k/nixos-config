{ pkgs, lib, ... }:

{
  home.packages = with pkgs; [
    protonplus     # GTK4 GUI manager for downloading custom Proton builds (GE-Proton, Wine-GE, etc.)
    protontricks   # Winetricks & DLL helper for Steam games
    (writeShellScriptBin "setup-assetto-corsa" ''
      set -euo pipefail
      AC_DIR="$HOME/.local/share/Steam/steamapps/common/assettocorsa"
      PREFIX_DIR="$HOME/.local/share/Steam/steamapps/compatdata/244210/pfx"

      echo "Setting up Assetto Corsa & Content Manager..."

      if [ -d "$AC_DIR" ]; then
        if [ -f "$AC_DIR/Content Manager.exe" ]; then
          if [ ! -f "$AC_DIR/AssettoCorsa.exe" ] || [ $(stat -c%s "$AC_DIR/AssettoCorsa.exe") -ne $(stat -c%s "$AC_DIR/Content Manager.exe") ]; then
            if [ -f "$AC_DIR/AssettoCorsa.exe" ] && [ ! -f "$AC_DIR/AssettoCorsa_original.exe" ]; then
              cp "$AC_DIR/AssettoCorsa.exe" "$AC_DIR/AssettoCorsa_original.exe"
              echo "✓ Backed up original launcher to AssettoCorsa_original.exe"
            fi
            rm -f "$AC_DIR/AssettoCorsa.exe"
            cp "$AC_DIR/Content Manager.exe" "$AC_DIR/AssettoCorsa.exe"
            chmod 755 "$AC_DIR/AssettoCorsa.exe"
            echo "✓ Content Manager swapped into AssettoCorsa.exe"
          else
            echo "✓ AssettoCorsa.exe is already Content Manager"
          fi
        else
          echo "⚠️ Content Manager.exe not found in $AC_DIR"
        fi
      else
        echo "⚠️ Assetto Corsa directory not found at $AC_DIR"
      fi

      if [ -d "$PREFIX_DIR" ]; then
        mkdir -p "$PREFIX_DIR/drive_c/Program Files (x86)/Steam/config/"
        VDF_LINK="$PREFIX_DIR/drive_c/Program Files (x86)/Steam/config/loginusers.vdf"
        if [ ! -L "$VDF_LINK" ]; then
          ln -sf "$HOME/.steam/root/config/loginusers.vdf" "$VDF_LINK"
          echo "✓ loginusers.vdf symlinked into Wine prefix"
        else
          echo "✓ loginusers.vdf is already symlinked"
        fi
      fi

      echo "Assetto Corsa Content Manager setup check complete!"
    '')
  ];

  home.activation.setupAssettoCorsa = lib.hm.dag.entryAfter ["writeBoundary"] ''
    $DRY_RUN_CMD ${pkgs.writeShellScript "setup-ac-activation" ''
      AC_DIR="$HOME/.local/share/Steam/steamapps/common/assettocorsa"
      PREFIX_DIR="$HOME/.local/share/Steam/steamapps/compatdata/244210/pfx"
      if [ -d "$AC_DIR" ] && [ -f "$AC_DIR/Content Manager.exe" ]; then
        if [ ! -f "$AC_DIR/AssettoCorsa.exe" ] || [ $(stat -c%s "$AC_DIR/AssettoCorsa.exe") -ne $(stat -c%s "$AC_DIR/Content Manager.exe") ]; then
          if [ -f "$AC_DIR/AssettoCorsa.exe" ] && [ ! -f "$AC_DIR/AssettoCorsa_original.exe" ]; then
            cp "$AC_DIR/AssettoCorsa.exe" "$AC_DIR/AssettoCorsa_original.exe"
          fi
          rm -f "$AC_DIR/AssettoCorsa.exe"
          cp "$AC_DIR/Content Manager.exe" "$AC_DIR/AssettoCorsa.exe"
          chmod 755 "$AC_DIR/AssettoCorsa.exe"
        fi
      fi
      if [ -d "$PREFIX_DIR" ]; then
        mkdir -p "$PREFIX_DIR/drive_c/Program Files (x86)/Steam/config/"
        VDF_LINK="$PREFIX_DIR/drive_c/Program Files (x86)/Steam/config/loginusers.vdf"
        if [ ! -L "$VDF_LINK" ]; then
          ln -sf "$HOME/.steam/root/config/loginusers.vdf" "$VDF_LINK"
        fi
      fi
    ''}
  '';

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
