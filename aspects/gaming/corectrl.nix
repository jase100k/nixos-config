{ config, pkgs, ... }:

{
  # CoreCtrl system configuration and polkit rules
  programs.corectrl = {
    enable = true;
  };

  # Unlocks OverDrive sysfs interface (voltage, clocks, VRAM frequencies)
  # Sets kernel boot parameter: amdgpu.ppfeaturemask=0xffffffff
  hardware.amdgpu.overdrive.enable = true;

  # Allow user jason to control GPU parameters without password prompts
  users.users.jason.extraGroups = [ "corectrl" ];
}
