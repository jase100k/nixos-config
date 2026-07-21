{ config, pkgs, ... }:

{
  imports = [
    ./plasma.nix
  ];

  home.username = "jason";
  home.homeDirectory = "/home/jason";
  home.stateVersion = "26.05";

  # Let Home Manager manage itself
  programs.home-manager.enable = true;

  # Git configuration
  programs.git = {
    enable = true;
    settings = {
      user.name = "Jason";
      user.email = "jase100k@protonmail.com";
      init.defaultBranch = "main";
    };
  };

  # Zsh configuration
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
      theme = "robbyrussell";
    };
  };

  # Starship prompt
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

  # Tmux
  programs.tmux = {
    enable = true;
    clock24 = true;
    keyMode = "vi";
    terminal = "tmux-256color";
  };

  # Neovim
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    withRuby = false;
    withPython3 = false;
  };

  # Alacritty is configured in plasma.nix

  # Browser (Firefox with gaming optimizations)
  programs.firefox = {
    enable = true;
    configPath = ".mozilla/firefox";
    profiles.default = {
      settings = {
        "media.ffmpeg.vaapi.enabled" = true;
        "gfx.webrender.all" = true;
        "layers.acceleration.force-enabled" = true;
      };
    };
  };

  # Discord
  programs.discord = {
    enable = true;
  };

  # MangoHud configuration
  xdg.configFile."MangoHud/MangoHud.conf" = {
    text = ''
      # MangoHud configuration
      fps
      cpu_temp
      gpu_temp
      ram
      vram
      cpu_power
      gpu_power
      frame_timing
      graph_temp
      font_size=24
      
      # Colors
      cpu_color=2E8B57
      gpu_color=5F9EA0
      vram_color=B8860B
      ram_color=B22222
    '';
  };

  # Gamescope wrapper
  xdg.configFile."gamescope/gamescope.env" = {
    text = ''
      # Gamescope environment
      MANGOHUD=1
    '';
  };

  # Gamemode configuration
  xdg.configFile."gamemode.ini" = {
    text = ''
      [general]
      reaper_thread_count=4
      renice=4
      
      [gpu]
      apply_gpu_optimisations=accept-responsibility
      gpu_device=0
      amd_performance_level=high
      
      [cpu]
      pin_current_process=1
      restrict_governor_performance=1
    '';
  };
}
