{ config, pkgs, ... }:

{
  time.timeZone = "Australia/Melbourne";

  networking.networkmanager.enable = true;

  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
    nerd-fonts.fira-code
    inter
    roboto
  ];

  environment.sessionVariables = {
    MOZ_ENABLE_WAYLAND = "1";
    EDITOR = "nvim";
    VISUAL = "nvim";
  };
}
