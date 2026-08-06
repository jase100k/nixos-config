{ config, pkgs, ... }:

{
  services.udev.extraRules = ''
    KERNEL=="ttyACM*", MODE="0666"
    KERNEL=="ttyUSB*", MODE="0666"

    # Pico FIDO / Pico Key hidraw access
    KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{idVendor}=="2e8a", ATTRS{idProduct}=="10fd", TAG+="uaccess", GROUP="users", MODE="0660"
    KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{idVendor}=="2e8a", ATTRS{idProduct}=="10fe", TAG+="uaccess", GROUP="users", MODE="0660"
  '';

  services.pcscd.enable = true;
}
