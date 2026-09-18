#!/usr/bin/env bash

# Apply nixos update using antigravity workflow
# This script mimics the antigravity workflow for NixOS updates

echo "Applying nixos update using antigravity workflow..."

# Commit the staged changes
echo "Committing staged changes..."
git add flake.lock flake.nix
git commit -m "build(flake): update flake inputs and dependencies"

# Run antigravity test build
echo "Running antigravity test build..."
if command -v antigravity &> /dev/null; then
    echo "Running antigravity test build..."
    antigravity --test-build
    if [ $? -eq 0 ]; then
        echo "Test build successful, applying update..."
        # Apply the system update (this would typically be done by antigravity)
        echo "Applying update with nixos-rebuild..."
        sudo nixos-rebuild switch --flake .#nixos-gaming
        echo "Update applied successfully!"
    else
        echo "Test build failed, update aborted"
        exit 1
    fi
else
    echo "antigravity not found, running direct rebuild..."
    # Fallback to direct rebuild if antigravity not available
    sudo nixos-rebuild switch --flake .#nixos-gaming
fi

echo "Update process complete!"