{ config, pkgs, ... }:

{
  home-manager.users.jason = {
    programs.discord.enable = true;
  };
}
