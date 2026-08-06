{ config, pkgs, ... }:

{
  home-manager.users.jason = {
    home.packages = [
      (pkgs.callPackage ../../pkgs/setup-assetto-corsa.nix {})
      (pkgs.callPackage ../../pkgs/setup-bakkesmod.nix {})
    ];
  };
}
