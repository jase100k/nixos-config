{ pkgs, ... }:

{
  programs.git = {
    enable = true;
    settings = {
      user.name = "Jason";
      user.email = "jase100k@protonmail.com";
      init.defaultBranch = "main";
    };
  };
}
