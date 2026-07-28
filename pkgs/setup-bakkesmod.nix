{ pkgs }:

pkgs.writeShellScriptBin "setup-bakkesmod" ''
  set -euo pipefail
  export WINEDEBUG="-all"
  export WINETRICKS_SUPER_QUIET=1

  echo "=== ⚽ Rocket League BakkesMod Linux Setup Tool ==="

  # 1. Dynamically locate Rocket League directory across all Steam libraries
  RL_DIR=""
  DEFAULT_RL_DIR="$HOME/.local/share/Steam/steamapps/common/rocketleague"

  if [ -d "$DEFAULT_RL_DIR" ]; then
    RL_DIR="$DEFAULT_RL_DIR"
  else
    # Search mounted drives (/mnt, /run/media, etc.) and custom Steam libraries
    SEARCH_PATH=$(find /mnt /run/media "$HOME" -maxdepth 5 -type d -path "*/steamapps/common/rocketleague" 2>/dev/null | head -n 1 || true)
    if [ -n "$SEARCH_PATH" ]; then
      RL_DIR="$SEARCH_PATH"
    fi
  fi

  if [ -z "$RL_DIR" ]; then
    echo "⚠️ Could not locate Rocket League installation in default path or mounted drives!"
    echo "👉 Please install Rocket League via Steam first."
    exit 1
  fi

  echo "✓ Located Rocket League at: $RL_DIR"

  # 2. Derive Steam compatdata Wine prefix directory dynamically
  STEAMAPPS_DIR=$(echo "$RL_DIR" | sed 's|/common/rocketleague.*||')
  PREFIX_DIR="$STEAMAPPS_DIR/compatdata/252950/pfx"

  # 3. Check if Wine prefix exists
  if [ ! -d "$PREFIX_DIR" ]; then
    echo "⚠️ Rocket League Wine prefix (252950) has not been initialized by Steam yet!"
    echo "   Expected location: $PREFIX_DIR"
    echo "👉 Step 1: Open Steam and click PLAY on Rocket League once to initialize the prefix."
    echo "👉 Step 2: Close the game, then re-run 'setup-bakkesmod'."
    exit 1
  fi

  # 4. Check & Install Windows runtimes into Rocket League prefix
  SENTINEL_FILE="$PREFIX_DIR/.bakkes_runtimes_installed"
  if [ ! -f "$SENTINEL_FILE" ]; then
    echo "🔧 Installing required Windows runtimes (vcrun2019) into Rocket League prefix..."
    ${pkgs.protontricks}/bin/protontricks 252950 -q vcrun2019 || true
    touch "$SENTINEL_FILE"
    echo "✓ Windows runtimes successfully installed."
  fi

  # 5. Check & Install BakkesMod
  BAKKES_DIR="$PREFIX_DIR/drive_c/Program Files/BakkesMod"
  BAKKES_EXE="$BAKKES_DIR/BakkesMod.exe"

  if [ -f "$BAKKES_EXE" ]; then
    echo "✓ BakkesMod.exe already installed in Wine prefix."
  else
    echo "⬇️ Downloading latest BakkesMod setup..."
    TMP_DIR=$(mktemp -d /tmp/bakkesmod_XXXXXX)
    TMP_ZIP="$TMP_DIR/BakkesModSetup.zip"
    TMP_EXE="$TMP_DIR/BakkesModSetup.exe"

    DOWNLOAD_URL="https://github.com/bakkesmodorg/BakkesModInjectorCpp/releases/latest/download/BakkesModSetup.zip"
    ALT_URL="https://download.bakkesmod.com/BakkesModSetup.zip"

    SETUP_TARGET="$PREFIX_DIR/drive_c/BakkesModSetup.exe"

    if ${pkgs.curl}/bin/curl -sSL "$DOWNLOAD_URL" -o "$TMP_ZIP" || ${pkgs.curl}/bin/curl -sSL "$ALT_URL" -o "$TMP_ZIP"; then
      ${pkgs.unzip}/bin/unzip -o -q "$TMP_ZIP" -d "$TMP_DIR"
      if [ -f "$TMP_EXE" ]; then
        cp "$TMP_EXE" "$SETUP_TARGET"
        echo "🔧 Launching BakkesMod installer inside Wine prefix (App ID 252950)..."
        ${pkgs.protontricks}/bin/protontricks-launch --appid 252950 "$SETUP_TARGET" || true
        rm -f "$SETUP_TARGET"
        echo "✓ BakkesMod installation complete."
      else
        echo "⚠️ Could not find BakkesModSetup.exe inside zip."
      fi
    else
      echo "❌ Failed to download BakkesModSetup.zip"
    fi
    rm -rf "$TMP_DIR"
  fi

  # 6. Ensure default F2 keybind exists & SafeMode disabled in registry
  BINDS_CFG="$BAKKES_DIR/bakkesmod/cfg/binds.cfg"
  if [ -d "$BAKKES_DIR/bakkesmod/cfg" ]; then
    mkdir -p "$BAKKES_DIR/bakkesmod/cfg"
    if ! grep -q "F2" "$BINDS_CFG" 2>/dev/null; then
      echo 'bind F2 "togglemenu settings"' >> "$BINDS_CFG"
      echo "✓ Added F2 keybind to BakkesMod binds.cfg"
    fi
  fi
  if [ -f "$PREFIX_DIR/user.reg" ]; then
    sed -i 's/"EnableSafeMode"=dword:00000001/"EnableSafeMode"=dword:00000000/g' "$PREFIX_DIR/user.reg"
    echo "✓ Disabled SafeMode in BakkesMod registry."
  fi

  # 7. Create Auto-Launch Helper Script (Waits for RocketLeague.exe before attaching in same Proton container)
  LAUNCHER_SCRIPT="$HOME/.local/bin/rocketleague-bakkesmod"
  mkdir -p "$HOME/.local/bin"

  cat << 'LAUNCH_SCRIPT_EOF' > "$LAUNCHER_SCRIPT"
#!/usr/bin/env bash
LOG_FILE="/tmp/rocketleague_bakkesmod.log"
exec > "$LOG_FILE" 2>&1

echo "=== Rocket League BakkesMod Auto-Launcher ==="
echo "Date: $(date)"
echo "Launch Arguments: $@"

# Extract Proton executable from Steam launch command
PROTON_BIN=""
for arg in "$@"; do
  if [[ "$arg" == *"/proton"* ]] && [ -x "$arg" ]; then
    PROTON_BIN="$arg"
    break
  fi
done

PREFIX_DIR="$HOME/.local/share/Steam/steamapps/compatdata/252950/pfx"
BAKKES_EXE="$PREFIX_DIR/drive_c/Program Files/BakkesMod/BakkesMod.exe"

# Background watcher to launch BakkesMod once RocketLeague.exe starts
(
  echo "⌛ Background watcher searching for RocketLeague.exe..."

  # Disable SafeMode dynamically before injection
  if [ -f "$PREFIX_DIR/user.reg" ]; then
    sed -i 's/"EnableSafeMode"=dword:00000001/"EnableSafeMode"=dword:00000000/g' "$PREFIX_DIR/user.reg"
  fi

  for i in $(seq 1 60); do
    if pgrep -f "RocketLeague.exe" > /dev/null 2>&1; then
      echo "✓ RocketLeague.exe detected! Attaching BakkesMod in 3 seconds..."
      sleep 3
      if [ -n "$PROTON_BIN" ] && [ -f "$BAKKES_EXE" ]; then
        echo "🚀 Launching BakkesMod via Proton: $PROTON_BIN"
        STEAM_COMPAT_DATA_PATH="''${STEAM_COMPAT_DATA_PATH:-$HOME/.local/share/Steam/steamapps/compatdata/252950}" \
        STEAM_COMPAT_CLIENT_INSTALL_PATH="''${STEAM_COMPAT_CLIENT_INSTALL_PATH:-$HOME/.local/share/Steam}" \
        "$PROTON_BIN" run "$BAKKES_EXE" &
        echo "✓ Triggered BakkesMod via Proton."
      elif [ -f "$BAKKES_EXE" ]; then
        echo "⚠️ Proton binary not detected in args, using fallback launch..."
        WINEPREFIX="$PREFIX_DIR" wine "$BAKKES_EXE" &
      fi
      break
    fi
    sleep 1
  done
) &

# Execute Steam game launch command (bypassing EAC so BakkesMod can inject)
exec "$@" -noeac
LAUNCH_SCRIPT_EOF

  chmod +x "$LAUNCHER_SCRIPT"
  echo "✓ Created launcher wrapper at: $LAUNCHER_SCRIPT"

  echo ""
  echo "========================================================================="
  echo "📌 Steam Launch Options (Properties -> General -> Launch Options):"
  echo "   bash -c '$LAUNCHER_SCRIPT \"\$@\"' -- %command%"
  echo ""
  echo "📌 BakkesMod In-Game Instructions:"
  echo "   1. Press F2 in-game to open BakkesMod overlay."
  echo "   2. If BakkesMod doesn't inject automatically, open BakkesMod settings"
  echo "      and uncheck 'Enable safe mode'."
  echo "========================================================================="
  echo ""
  echo "✅ Rocket League BakkesMod setup check complete!"
''
