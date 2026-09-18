#!/usr/bin/env bash

# Apply the nixos update by committing changes and rebuilding
# This script assumes you have a custom "update" alias/function

echo "Applying nixos update..."

# Commit the staged changes
echo "Committing staged changes..."
git add flake.lock flake.nix
git commit -m "build(flake): update flake inputs and dependencies"

# Apply the system update using your custom update command
echo "Running custom update command..."
update

echo "Update complete!"