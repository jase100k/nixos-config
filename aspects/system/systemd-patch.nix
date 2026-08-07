{ config, pkgs, lib, ... }:

{
  # Systemd overlay: disable userdb and homed in systemd Meson compilation flags
  # Completely strips userdbd and homed daemons (removing birthDate & age verification APIs)
  # Preserves stock NixOS systemd source and all NixOS patches with 100% clean compilation
  nixpkgs.overlays = [
    (final: prev: {
      systemd = prev.systemd.overrideAttrs (oldAttrs: {
        mesonFlags = (prev.lib.filter (flag: !(prev.lib.hasPrefix "-Dhomed=" flag) && !(prev.lib.hasPrefix "-Duserdb=" flag)) oldAttrs.mesonFlags) ++ [
          "-Dhomed=disabled"
          "-Duserdb=false"
        ];
      });
    })
  ];
}


