{ config, pkgs, inputs, ... }:

{
  # Overlay must be at NixOS level - home-manager.useGlobalPkgs = true
  nixpkgs.overlays = [
    inputs.deepseek-harness.overlays.default
    # dsh 0.1.7-alpha.x bundle-check fails to resolve plugins in the
    # "standard" preset during the install check. Skip the flaky smoke
    # test; the upstream escape hatch documented by the package.
    (final: prev: {
      dsh = prev.dsh // {
        dsh = prev.dsh.dsh.overrideAttrs (old: {
          dontDshBundleCheck = true;
        });
      };
    })
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
