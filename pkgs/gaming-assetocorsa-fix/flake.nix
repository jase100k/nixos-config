{
  description = "Assetto Corsa + Content Manager setup script and Home Manager module";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs }: {
    packages.x86_64-linux = let
      pkgs = nixpkgs.legacyPackages.x86_64-linux;
    in {
      setup-assetto-corsa = pkgs.writeShellScriptBin "setup-assetto-corsa" ''
        set -euo pipefail
        AC_DIR="$HOME/.local/share/Steam/steamapps/common/assettocorsa"
        PREFIX_DIR="$HOME/.local/share/Steam/steamapps/compatdata/244210/pfx"

        echo "Setting up Assetto Corsa & Content Manager..."

        if [ -d "$AC_DIR" ]; then
          if [ ! -f "$AC_DIR/Content Manager.exe" ]; then
            echo "⚠️ Content Manager.exe not found in $AC_DIR. Downloading latest Content Manager from acstuff.ru..."
            TMP_ZIP=$(mktemp /tmp/cm_XXXXXX.zip)
            if ${pkgs.curl}/bin/curl -sSL "https://acstuff.ru/app/latest.zip" -o "$TMP_ZIP"; then
              ${pkgs.unzip}/bin/unzip -o -q "$TMP_ZIP" "Content Manager.exe" -d "$AC_DIR"
              rm -f "$TMP_ZIP"
              echo "✓ Successfully downloaded and extracted Content Manager.exe into $AC_DIR"
            else
              echo "❌ Failed to download Content Manager.exe from acstuff.ru"
              rm -f "$TMP_ZIP"
            fi
          fi

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
      '';
      default = self.packages.x86_64-linux.setup-assetto-corsa;
    };

    homeManagerModules.default = { config, lib, pkgs, ... }: {
      options.services.assetto-corsa-fix = {
        enable = lib.mkEnableOption "Assetto Corsa Content Manager setup and loginusers.vdf symlink fix";
        autoRunOnSwitch = lib.mkOption {
          type = lib.types.bool;
          default = true;
          description = "Automatically run setup script on home-manager activation switch";
        };
      };

      config = lib.mkIf config.services.assetto-corsa-fix.enable {
        home.packages = [ self.packages.${pkgs.stdenv.hostPlatform.system}.setup-assetto-corsa ];
        home.activation.setupAssettoCorsa = lib.mkIf config.services.assetto-corsa-fix.autoRunOnSwitch (
          lib.hm.dag.entryAfter [ "writeBoundary" ] ''
            $DRY_RUN_CMD ${self.packages.${pkgs.stdenv.hostPlatform.system}.setup-assetto-corsa}/bin/setup-assetto-corsa
          ''
        );
      };
    };
  };
}
