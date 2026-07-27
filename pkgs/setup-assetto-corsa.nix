{ pkgs }:

pkgs.writeShellScriptBin "setup-assetto-corsa" ''
  set -euo pipefail

  echo "=== 🏎️ Assetto Corsa Linux Setup Tool ==="

  # 1. Dynamically locate Assetto Corsa directory across all Steam libraries
  AC_DIR=""
  DEFAULT_AC_DIR="$HOME/.local/share/Steam/steamapps/common/assettocorsa"

  if [ -d "$DEFAULT_AC_DIR" ]; then
    AC_DIR="$DEFAULT_AC_DIR"
  else
    # Search all mounted drives (/mnt, /run/media, etc.) and custom Steam libraries
    SEARCH_PATH=$(find /mnt /run/media "$HOME" -maxdepth 5 -type d -path "*/steamapps/common/assettocorsa" 2>/dev/null | head -n 1 || true)
    if [ -n "$SEARCH_PATH" ]; then
      AC_DIR="$SEARCH_PATH"
    fi
  fi

  if [ -z "$AC_DIR" ]; then
    echo "⚠️ Could not locate Assetto Corsa installation in default path or mounted drives!"
    echo "👉 Please install Assetto Corsa via Steam first."
    exit 1
  fi

  echo "✓ Located Assetto Corsa at: $AC_DIR"

  # 2. Derive Steam compatdata Wine prefix directory dynamically
  STEAMAPPS_DIR=$(echo "$AC_DIR" | sed 's|/common/assettocorsa.*||')
  PREFIX_DIR="$STEAMAPPS_DIR/compatdata/244210/pfx"
  SENTINEL_FILE="$PREFIX_DIR/.ac_runtimes_installed"

  # 3. Download Content Manager if missing & create no-space executable link
  if [ ! -f "$AC_DIR/Content Manager.exe" ]; then
    echo "⬇️ Downloading latest Content Manager.exe..."
    TMP_ZIP=$(mktemp /tmp/cm_XXXXXX.zip)
    ${pkgs.curl}/bin/curl -sSL "https://acstuff.ru/app/latest.zip" -o "$TMP_ZIP"
    ${pkgs.unzip}/bin/unzip -o -q "$TMP_ZIP" "Content Manager.exe" -d "$AC_DIR"
    rm -f "$TMP_ZIP"
    echo "✓ Content Manager downloaded."
  fi
  if [ -f "$AC_DIR/Content Manager.exe" ] && [ ! -f "$AC_DIR/ContentManager.exe" ]; then
    cp "$AC_DIR/Content Manager.exe" "$AC_DIR/ContentManager.exe"
    echo "✓ Created ContentManager.exe (no space) executable."
  fi

  # 4. Check if Wine prefix exists
  if [ ! -d "$PREFIX_DIR" ]; then
    echo "⚠️ Assetto Corsa Wine prefix (244210) has not been initialized by Steam yet!"
    echo "   Expected location: $PREFIX_DIR"
    echo "👉 Step 1: Open Steam and click PLAY on Assetto Corsa once to initialize the prefix."
    echo "👉 Step 2: Close the game, then re-run 'setup-assetto-corsa'."
    exit 1
  fi

  # 5. Protontricks runtimes installation (Idempotent with sentinel check)
  if [ -f "$SENTINEL_FILE" ]; then
    echo "✓ Windows runtimes (.NET 4.8, C++, DirectX, Fonts) already installed in prefix. Skipping protontricks."
  else
    echo "🔧 Installing required Windows runtimes into Assetto Corsa prefix (244210)..."
    ${pkgs.protontricks}/bin/protontricks 244210 -q vcrun2019 dotnet48 d3dcompiler_43 d3dx11_43 corefonts || true
    touch "$SENTINEL_FILE"
    echo "✓ Windows runtimes successfully installed."
  fi

  # 6. Create Steam loginusers.vdf symlink
  STEAM_CFG_DIR="$PREFIX_DIR/drive_c/Program Files (x86)/Steam/config"
  mkdir -p "$STEAM_CFG_DIR"
  VDF_SRC="$HOME/.steam/root/config/loginusers.vdf"
  if [ -f "$VDF_SRC" ]; then
    ln -sf "$VDF_SRC" "$STEAM_CFG_DIR/loginusers.vdf"
    echo "✓ Steam loginusers.vdf symlinked into Wine prefix."
  fi

  # 7. Dynamically format Windows path for Content Manager prompt
  WIN_AC_PATH="Z:$(echo "$AC_DIR" | sed 's|/|\\|g')"

  echo ""
  echo "📌 If Content Manager asks for the Assetto Corsa root directory, paste this exact Windows path:"
  echo "   $WIN_AC_PATH"
  echo ""
  echo "✅ Setup complete! Launch Content Manager using your Non-Steam shortcut."
''
