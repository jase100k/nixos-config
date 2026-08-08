{ config, pkgs, ... }:

{
  users.users.jason = {
    isNormalUser = true;
    description = "Jason";
    extraGroups = [ "networkmanager" "wheel" "gamemode" "video" "input" "libvirtd" "dialout" "uinput" ];
    shell = pkgs.zsh;
  };

  home-manager.backupFileExtension = "backup";

  home-manager.users.jason = {
    home.username = "jason";
    home.homeDirectory = "/home/jason";
    home.stateVersion = "26.05";
    programs.home-manager.enable = true;
  };


  virtualisation.libvirtd.enable = true;
  programs.virt-manager.enable = true;
  virtualisation.spiceUSBRedirection.enable = true;

  environment.systemPackages = with pkgs; [
    wget
    curl
    git
    vim
    htop
    btop
    tmux
    unzip
    p7zip
    usbutils
    wlr-randr
    grim
    slurp
    wl-clipboard
    xclip
    satty
    wayfreeze
    gcc
    gnumake
    cmake
    nfs-utils
    adw-gtk3
    nwg-look
    xcursor-themes
    bibata-cursors
  ];
}
