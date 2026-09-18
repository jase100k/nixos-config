{
  description = "NixOS Gaming Configuration (Dendritic Aspect Architecture)";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    # Denful import-tree - recursive module tree loader for Dendritic pattern
    import-tree.url = "github:denful/import-tree";

    # CachyOS kernel - do NOT override nixpkgs, needed for binary cache hits
    nix-cachyos-kernel.url = "github:xddxdd/nix-cachyos-kernel/release";

    # MangoWM - Wayland compositor
    mangowm = {
      url = "github:mangowm/mango";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Niri - Scrollable tiling Wayland compositor
    niri = {
      url = "github:sodiboo/niri-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Millennium - Steam client modding framework (DO NOT follows nixpkgs - pinned for Bun FOD)
    millennium.url = "github:SteamClientHomebrew/Millennium?dir=packages/nix";

    # Noctalia v5 - Desktop shell (bar, launcher, notifications)
    # Do NOT follows nixpkgs - required for binary cache hits
    noctalia.url = "github:noctalia-dev/noctalia/cachix";

    # Noctalia Greeter - Minimal login greeter matching Noctalia shell aesthetic
    noctalia-greeter = {
      url = "github:noctalia-dev/noctalia-greeter";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Google Antigravity - agentic IDE/CLI
    antigravity-nix = {
      url = "github:jacopone/antigravity-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Home Manager for user-level configs
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Assetto Corsa & Content Manager fix module
    gaming-assetocorsa-fix = {
      url = "path:./pkgs/gaming-assetocorsa-fix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Zen Browser - modern Firefox derivative
    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Stylix - universal system-wide auto-theming engine
    stylix = {
      url = "github:danth/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Torlink - terminal torrent finder & downloader
    torlink = {
      url = "github:baairon/torlink";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Pi - minimalist AI coding agent harness
    pi-flake = {
      url = "github:ChauDucToan/pi-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, nix-cachyos-kernel, mangowm, niri, millennium, noctalia, noctalia-greeter, antigravity-nix, home-manager, gaming-assetocorsa-fix, stylix, import-tree, ... }@inputs: {

    nixosConfigurations.nixos-gaming = nixpkgs.lib.nixosSystem {
      specialArgs = { inherit inputs; };
      modules = [
        { nixpkgs.hostPlatform = "x86_64-linux"; }
        { disabledModules = [ "programs/wayland/mango.nix" ]; }
        ./hosts/nixos-gaming

        # Compositors & Desktop System Modules
        mangowm.nixosModules.mango
        noctalia.nixosModules.default
        noctalia-greeter.nixosModules.default

        # Home Manager Module Setup
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.backupFileExtension = "hm-backup";
          home-manager.extraSpecialArgs = { inherit inputs; };
          home-manager.sharedModules = [
            inputs.mangowm.hmModules.mango
            inputs.niri.homeModules.niri
            inputs.gaming-assetocorsa-fix.homeManagerModules.default
            inputs.pi-flake.homeManagerModules.default
          ];
        }

        # Automatically discover and load all aspects
        (import-tree ./aspects)
      ];
    };
  };
}
