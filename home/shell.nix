{ pkgs, ... }:

{
  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    enableCompletion = true;
    syntaxHighlighting.enable = true;

    shellAliases = {
      ll = "ls -la";
      gs = "git status";
      update = "sudo nixos-rebuild switch --flake /etc/nixos#nixos-gaming";
      cleanup = "nix-collect-garbage -d";
      search = "nix search nixpkgs";
      nixcommit = "sudo git -C /etc/nixos add -A && sudo git -C /etc/nixos commit";
    };

    oh-my-zsh = {
      enable = true;
      plugins = [ "git" "sudo" "history" "dirhistory" ];
    };
  };

  programs.starship = {
    enable = true;
    settings = {
      add_newline = true;
      character = {
        success_symbol = "[❯](bold green)";
        error_symbol = "[❯](bold red)";
      };
    };
  };

  programs.tmux = {
    enable = true;
    clock24 = true;
    keyMode = "vi";
    terminal = "tmux-256color";
  };
}
