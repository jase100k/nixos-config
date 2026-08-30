{ config, pkgs, ... }:

{
  time.timeZone = "Australia/Melbourne";

  i18n.defaultLocale = "en_US.UTF-8";
  i18n.supportedLocales = [ "en_US.UTF-8/UTF-8" ];

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
