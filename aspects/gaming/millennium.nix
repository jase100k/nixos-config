{ config, pkgs, inputs, ... }:

{
  nixpkgs.overlays = [
    inputs.millennium.overlays.default
  ];

  home-manager.users.jason = {
    xdg.configFile."millennium/config.json" = {
      source = ./_millennium-config.json;
      force = true;
    };
  };
}
