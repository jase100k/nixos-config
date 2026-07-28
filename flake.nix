{
  description = "NixOS Gaming Configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

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

    # Plasma Manager for declarative KDE config
    plasma-manager = {
      url = "github:nix-community/plasma-manager";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };

    # Assetto Corsa & Content Manager fix module
    gaming-assetocorsa-fix = {
      url = "path:./pkgs/gaming-assetocorsa-fix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, nix-cachyos-kernel, mangowm, niri, millennium, noctalia, antigravity-nix, home-manager, plasma-manager, gaming-assetocorsa-fix, ... }@inputs: {
    nixosConfigurations.nixos-gaming = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit inputs; };
      modules = [
        { disabledModules = [ "programs/wayland/mango.nix" ]; }
        ./hosts/nixos-gaming

        # MangoWM compositor
        mangowm.nixosModules.mango

        # Noctalia v5 desktop shell
        noctalia.nixosModules.default

        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.backupFileExtension = "hm-backup";
          home-manager.extraSpecialArgs = { inherit inputs; };
          home-manager.sharedModules = [
            inputs.plasma-manager.homeModules.plasma-manager
            inputs.mangowm.hmModules.mango
            inputs.niri.homeModules.niri
            inputs.gaming-assetocorsa-fix.homeManagerModules.default
          ];
          home-manager.users.jason = import ./modules/home;
        }
      ];
    };
  };
}
