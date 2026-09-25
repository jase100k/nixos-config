{ config, pkgs, ... }:

{
  programs.zsh.enable = true;

  home-manager.users.jason = {
    home.sessionVariables.LLAMA_SERVER_URL = "http://127.0.0.1:8000";

    home.packages = with pkgs; [
      openssh
      yazi
      orca-slicer
      wl-clipboard
    ];

    programs.zsh = {
      enable = true;
      autosuggestion.enable = true;
      enableCompletion = true;
      syntaxHighlighting.enable = true;
      initContent = ''
        eval "$(starship init zsh)"

        function yy() {
          local tmp="$(mktemp -t "yazi-cwd.XXXXXX")"
          yazi "$@" --cwd-file="$tmp"
          if cwd="$(cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
            builtin cd -- "$cwd"
          fi
          rm -f -- "$tmp"
        }
      '';

      shellAliases = {
        ll = "ls -la";
        gs = "git status";
        update = "sudo nixos-rebuild switch --flake /etc/nixos#nixos-gaming";
        cleanup = "nix-collect-garbage -d";
        search = "nix search nixpkgs";
        nixcommit = "sudo git -C /etc/nixos add -A && sudo git -C /etc/nixos commit";
        hf = "nix shell nixpkgs#python3.pkgs.huggingface-hub -c hf";
        orca-slicer = "GTK_THEME=Adwaita:dark orca-slicer";
        c = "wl-copy";
        copy = "wl-copy";
        p = "wl-paste";
        paste = "wl-paste";
      };

      oh-my-zsh = {
        enable = true;
        plugins = [ "git" "sudo" "history" "dirhistory" ];
      };
    };

    programs.tmux = {
      enable = true;
      mouse = true;
      clock24 = true;
      keyMode = "vi";
      terminal = "tmux-256color";
    };
  };
}
