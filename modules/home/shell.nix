{ pkgs, ... }:

{
  home.packages = [
    pkgs.starship
  ];

  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    enableCompletion = true;
    syntaxHighlighting.enable = true;
    initContent = ''
      eval "$(starship init zsh)"
    '';

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

  programs.tmux = {
    enable = true;
    clock24 = true;
    keyMode = "vi";
    terminal = "tmux-256color";
  };

  programs.ssh = {
    enable = true;
    matchBlocks = {
      "truenas" = {
        hostname = "192.168.13.22";
        user = "root";
        identityFile = "~/.ssh/id_ed25519";
      };
      "192.168.13.22" = {
        user = "root";
        identityFile = "~/.ssh/id_ed25519";
      };
    };
  };
}
