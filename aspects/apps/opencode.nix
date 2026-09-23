{ config, pkgs, inputs, ... }:

let
  opencode-pinned = inputs.nixpkgs-opencode.legacyPackages.${pkgs.stdenv.hostPlatform.system}.opencode;
in
{
  home-manager.users.jason = {
    home.packages = [
      opencode-pinned
    ];

    xdg.configFile."opencode/tui.json".text = ''
      {
        "$schema": "https://opencode.ai/tui.json",
        "theme": "matugen"
      }
    '';
  };
}
