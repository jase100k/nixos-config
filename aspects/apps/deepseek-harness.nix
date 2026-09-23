{ config, pkgs, inputs, ... }:

{
  # Overlay must be at NixOS level - home-manager.useGlobalPkgs = true
  nixpkgs.overlays = [
    inputs.deepseek-harness.overlays.default
  ];

  home-manager.users.jason = { config, pkgs, ... }: {
    imports = [ inputs.deepseek-harness.homeModules.default ];

    programs.dsh = {
      enable = true;
      profiles.tui = {
        bundles = [ pkgs.dsh.bundles.tui ];
        mode = "managed";
      };
      defaultProfile = config.programs.dsh.profiles.tui.materializedName;
    };
  };
}
