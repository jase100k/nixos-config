{ config, pkgs, ... }:

{
  # Option 2: Apply systemd overlay patch to strip birthDate / userdb fields
  # Keeps stock NixOS systemd security updates intact while stripping privacy-invasive fields
  nixpkgs.overlays = [
    (final: prev: {
      systemd = prev.systemd.overrideAttrs (oldAttrs: {
        patches = (oldAttrs.patches or []) ++ [
          ../../patches/strip-systemd-userdb.patch
        ];
      });
    })
  ];
}
