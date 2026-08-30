{ config, pkgs, ... }:

{
  # RetroArch GUI frontend with bundled libretro emulator cores & Standalone Emulators
  environment.systemPackages = [
    (pkgs.retroarch.withCores (cores: with cores; [
      bsnes
      snes9x
      genesis-plus-gx
      mupen64plus
      nestopia
      mgba
      gambatte
      beetle-psx-hw
      pcsx-rearmed
      ppsspp
      desmume
      flycast
      fbneo
      dolphin
    ]))

    # Nintendo Switch Emulator
    pkgs.ryubing
  ];
}
