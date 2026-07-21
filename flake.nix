{
  description = "NixOS Gaming Configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    
    # CachyOS kernel - do NOT override nixpkgs, needed for binary cache hits
    nix-cachyos-kernel.url = "github:xddxdd/nix-cachyos-kernel/release";

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
  };

  outputs = { self, nixpkgs, nix-cachyos-kernel, home-manager, plasma-manager, ... }@inputs: {
    nixosConfigurations.nixos-gaming = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit inputs; };
      modules = [
        ./configuration.nix
        ./hardware-configuration.nix

        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.backupFileExtension = "hm-backup";
          home-manager.sharedModules = [
            inputs.plasma-manager.homeModules.plasma-manager
          ];
          home-manager.users.jason = import ./home.nix;
        }
      ];
    };
  };
}
