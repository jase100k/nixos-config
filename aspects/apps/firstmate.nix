{ config, pkgs, inputs, ... }:

# Firstmate - agent distro for running a crew of agents.
# The distro itself lives as a git checkout (~/Projects/firstmate); this
# aspect provides its CLI dependencies and session backend (herdr).
let
  treehouse = inputs.treehouse.packages.${pkgs.stdenv.hostPlatform.system}.default;
in
{
  home-manager.users.jason = {
    home.packages = [
      pkgs.gh
      pkgs.nodejs
      pkgs.jq
      pkgs.tmux
      treehouse
    ];
  };
}