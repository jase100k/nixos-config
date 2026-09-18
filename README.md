# NixOS Update Instructions

## Current Status
You have prepared updates to your NixOS configuration with the following changes:
- Updated flake.lock with newer versions of dependencies
- Added new aspects (pi.nix, firewall.nix)
- Updated nix-settings.nix

## Applying the Update

Since you have a custom `update` alias/function, you can apply the changes with:

```bash
# Commit the staged changes
git add flake.lock flake.nix
git commit -m "build(flake): update flake inputs and dependencies"

# Apply the system update using your custom update command
update
```

## Alternative: Direct Application

If you don't have the `update` alias set up, you can manually apply the update with:

```bash
# Commit changes
git add flake.lock flake.nix
git commit -m "build(flake): update flake inputs and dependencies"

# Rebuild the system
sudo nixos-rebuild switch --flake .#nixos-gaming
```

## Creating the Update Alias

To create the `update` alias for future use:

```bash
# Add to ~/.bashrc
echo 'alias update="git add flake.lock flake.nix && git commit -m \"build(flake): update flake inputs and dependencies\" && sudo nixos-rebuild switch --flake .#nixos-gaming"' >> ~/.bashrc
source ~/.bashrc
```

The update process will:
1. Commit your staged changes
2. Rebuild the system with the new dependencies
3. Apply the updated configuration

Note: Your system is currently running version 26.11.20260910.8ce4ef6