{ config, pkgs, ... }:

{
  home-manager.users.jason = {
    home.packages = [
      pkgs.vscode-fhs
    ];
  };
}
