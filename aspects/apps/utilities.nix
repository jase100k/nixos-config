{ config, pkgs, ... }:

{
  # Thunar file manager & thumbnail support
  programs.thunar = {
    enable = true;
    plugins = with pkgs; [
      thunar-archive-plugin
      thunar-volman
    ];
  };
  services.tumbler.enable = true;

  # Standalone GUI Desktop Utilities
  environment.systemPackages = with pkgs; [
    nemo
    nemo-fileroller
    file-roller
    loupe
    zathura
    mission-center
    gnome-calculator
  ];
}
