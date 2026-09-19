{ config, pkgs, inputs, lib, ... }:

{
  home-manager.users.jason = {
    programs.pi-coding-agent = {
      enable = true;
      package = inputs.pi-flake.packages.${pkgs.stdenv.hostPlatform.system}.default;
      extraEnv = {
        PATH = pkgs.lib.makeBinPath [
          pkgs.nodejs
          pkgs.python3
          pkgs.git
          pkgs.ripgrep
          pkgs.nix
          pkgs.coreutils
          pkgs.bashInteractive
        ];
        SHELL = "${pkgs.bashInteractive}/bin/bash";
        NIXOS = "1";
      };
    };
  };
}
