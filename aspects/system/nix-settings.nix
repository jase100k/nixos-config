{ config, pkgs, ... }:

{
  nixpkgs.config.allowUnfree = true;

  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    auto-optimise-store = true;
    cores = 16;
    trusted-users = [ "root" "jason" ];
    extra-substituters = [
      "https://noctalia.cachix.org"
      "https://cachyos.cachix.org"
    ];
    extra-trusted-public-keys = [
      "noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4="
      "cachyos.cachix.org-1:95b2C3UaaPJUGlGLM22sm6lR4n9wVUqBLVn86uu03j8="
    ];
  };

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };

  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
    stdenv.cc.cc
    zlib
    fuse3
    alsa-lib
    at-spi2-core
    cups
    libdrm
    libGL
    libxkbcommon
    nspr
    nss
    libX11
    libXcursor
    libXi
    libXrandr
    libXrender
    libXxf86vm
    libxcb
  ];
}
