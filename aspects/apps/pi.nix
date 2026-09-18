{ config, pkgs, inputs, ... }:

{
  home-manager.users.jason = {
    programs.pi-coding-agent = {
      enable = true;
      package = inputs.pi-flake.packages.${pkgs.stdenv.hostPlatform.system}.default;
    };
  };
}
