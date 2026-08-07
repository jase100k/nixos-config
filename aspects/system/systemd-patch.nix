{ config, pkgs, inputs, ... }:

{
  # Systemd overlay: replace systemd source with liberated-systemd repository
  # Strips birthDate / userdb fields cleanly without malformed raw patch errors
  nixpkgs.overlays = [
    (final: prev: {
      systemd = prev.systemd.overrideAttrs (oldAttrs: {
        src = inputs.liberated-systemd;
      });
    })
  ];
}

