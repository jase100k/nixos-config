{ config, pkgs, lib, ... }:

let
  pi-agent-studio = pkgs.vscode-utils.buildVscodeExtension {
    pname = "pi-agent-studio";
    version = "1.3.10";

    src = pkgs.fetchurl {
      url = "https://marketplace.visualstudio.com/_apis/public/gallery/publishers/johnny-zhao/vsextensions/pi-agent-studio/1.3.10/vspackage";
      sha256 = "06cr9m7wnfsp2jg9ipdz4zdijm9m1v9ybs3jlcayvq41zq8s4zis";
      name = "pi-agent-studio-1.3.10.vsix";
      curlOptsList = [ "--compressed" ];
    };

    vscodeExtUniqueId = "johnny-zhao.pi-agent-studio";
    vscodeExtPublisher = "johnny-zhao";
    vscodeExtName = "pi-agent-studio";

    meta = {
      description = "Pi Agent Studio - pi coding agent integration for VS Code";
      license = pkgs.lib.licenses.mit;
    };
  };

  # VSCodium ships the blue Microsoft code.png on Linux, so the tray/launcher
  # shows the wrong icon. Install the official red VSCodium icon into hicolor
  # (the universal fallback theme) so any icon resolver finds it.
  vscodiumIconSizes = [ 16 22 24 32 48 64 96 128 256 512 ];

  vscodiumIcons = pkgs.runCommandLocal "vscodium-hicolor-icons" { } ''
    mkdir -p $out
    for s in ${toString vscodiumIconSizes}; do
      ${pkgs.imagemagick}/bin/convert ${./../../pkgs/vscodium-icon/vscodium-icon.png} \
        -resize "''${s}x''${s}" "$out/vscodium-''${s}.png"
    done
  '';

  vscodiumIconFiles = lib.listToAttrs (map (s: {
    name = "icons/hicolor/${toString s}x${toString s}/apps/vscodium.png";
    value.source = "${vscodiumIcons}/vscodium-${toString s}.png";
  }) vscodiumIconSizes);
in
{
  home-manager.users.jason = {
    programs.vscodium = {
      enable = true;
      package = pkgs.vscodium.fhs;
      profiles.default.extensions = [
        pi-agent-studio
      ];
    };

    xdg.dataFile = vscodiumIconFiles;
  };
}