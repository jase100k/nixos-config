{ config, pkgs, lib, ... }:

let
  pname = "nuvio";
  version = "0.1.22-alpha";

  src = pkgs.fetchurl {
    url = "https://github.com/NuvioMedia/NuvioDesktop/releases/download/${version}/Nuvio-Linux-x86_64-${version}.AppImage";
    sha256 = "1jcrsax7f0lm7q4657q1spx1v57zz5imq2h61cy3z7x3682zsjr0";
  };

  appimageContents = pkgs.appimageTools.extract {
    inherit pname version src;
  };

  nuvio = pkgs.appimageTools.wrapType2 {
    inherit pname version src;

    extraPkgs = pkgs: with pkgs; [
      libGL
      vulkan-loader
      libx11
      libxcursor
      libxrandr
      libxi
      libxcomposite
      libglvnd
      alsa-lib
      mpv
      webkitgtk_4_1
      gtk3
      cairo
      glib
      gst_all_1.gstreamer
      gst_all_1.gst-plugins-base
      gst_all_1.gst-plugins-good
      gst_all_1.gst-plugins-bad
      gst_all_1.gst-plugins-ugly
      gst_all_1.gst-libav
      ffmpeg
      libpulseaudio
      pipewire
      libva
      libvdpau
      wayland
      mesa
      at-spi2-core
    ];

    extraInstallCommands = ''
      install -m 444 -D ${appimageContents}/Nuvio.desktop $out/share/applications/Nuvio.desktop
      install -m 444 -D ${appimageContents}/Nuvio.png $out/share/icons/hicolor/512x512/apps/Nuvio.png
      substituteInPlace $out/share/applications/Nuvio.desktop \
        --replace-fail 'Exec=AppRun' 'Exec=nuvio'
    '';
  };
in
{
  # Nuvio - open-source streaming media player
  environment.systemPackages = [
    nuvio
  ];
}
