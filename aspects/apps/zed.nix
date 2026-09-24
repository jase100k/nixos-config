{ config, pkgs, inputs, ... }:

{
  home-manager.users.jason = {
    home.packages = [
      inputs.zed.packages.${pkgs.stdenv.hostPlatform.system}.default
    ];
  };
}
