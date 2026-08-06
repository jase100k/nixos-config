{ config, pkgs, ... }:

{
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
    extraConfig.pipewire."92-low-latency" = {
      "context.properties" = {
        "default.clock.rate" = 48000;
        "default.clock.quantum" = 64;
        "default.clock.min-quantum" = 32;
        "default.clock.max-quantum" = 512;
      };
    };
  };

  services.pulseaudio.enable = false;

  environment.systemPackages = [
    pkgs.pavucontrol
  ];
}
