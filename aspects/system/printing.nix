{ config, pkgs, ... }:

{
  services.printing = {
    enable = true;
    extraConf = ''
      <Location />
        Order deny,allow
        Deny from all
        Allow from 127.0.0.1
        Allow from 192.168.11.*
      </Location>
    '';
  };

  hardware.printers.ensurePrinters = [
    {
      name = "Canon";
      deviceUri = "ipp://192.168.11.220/ipp/print";
      model = "drv:///cupsfilters.drv/pwgrast.ppd";
      description = "Canon Network Printer";
    }
  ];

  hardware.printers.ensureDefaultPrinter = "Canon";
}
