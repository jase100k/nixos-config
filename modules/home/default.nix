{ config, pkgs, inputs, ... }:

{
  imports = [
    ./shell.nix
    ./terminal.nix
    ./editors.nix
    ./git.nix
    ./browsers.nix
    ./messaging.nix
    ./gaming.nix
    ./wm
    ./desktop
  ];

  home.username = "jason";
  home.homeDirectory = "/home/jason";
  home.stateVersion = "26.05";

  programs.home-manager.enable = true;

  home.packages = with pkgs; [
    brave
    floorp-bin
    jq
    inputs.antigravity-nix.packages.${pkgs.stdenv.hostPlatform.system}.default
    inputs.antigravity-nix.packages.${pkgs.stdenv.hostPlatform.system}.google-antigravity-ide
    inputs.antigravity-nix.packages.${pkgs.stdenv.hostPlatform.system}.google-antigravity-cli
  ];
}
