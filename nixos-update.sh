#!/usr/bin/env bash
# NixOS Update Script for Your System
# Properly updates your NixOS flake-based configuration

set -euo pipefail

echo "=== NixOS Update Script ==="
echo "System: nixos-gaming"
echo "Configuration: $(pwd)"
echo ""

# Function to check prerequisites
check_prerequisites() {
    if ! command -v nix &> /dev/null; then
        echo "Error: Nix is not installed"
        exit 1
    fi
    
    if [[ ! -f "flake.nix" ]]; then
        echo "Error: This doesn't appear to be a NixOS flake directory"
        exit 1
    fi
    
    if [[ ! -d ".git" ]]; then
        echo "Error: This is not a git repository"
        exit 1
    fi
}

# Function to update flake inputs
update_flake() {
    echo "Updating flake inputs..."
    nix flake update
    echo "Flake inputs updated successfully"
}

# Function to commit changes
commit_changes() {
    echo "Committing changes..."
    git add flake.lock flake.nix 2>/dev/null || true
    git commit -m "build(flake): update flake inputs and dependencies" 2>/dev/null || {
        echo "No changes to commit"
    }
    echo "Changes committed"
}

# Function to test build
test_build() {
    echo "Testing build..."
    if sudo nixos-rebuild test --flake .#nixos-gaming 2>/dev/null; then
        echo "Test build successful"
        return 0
    else
        echo "Test build failed"
        return 1
    fi
}

# Function to apply update
apply_update() {
    echo "Applying update..."
    sudo nixos-rebuild switch --flake .#nixos-gaming
    echo "Update applied successfully"
}

# Main execution
main() {
    check_prerequisites
    
    echo "Current system: $(readlink -f /nix/var/nix/profiles/system)"
    echo ""
    
    # Update flake inputs
    update_flake
    
    # Commit changes
    commit_changes
    
    # Test build
    if test_build; then
        # Apply update
        apply_update
    else
        echo "Update aborted due to test failure"
        exit 1
    fi
    
    echo ""
    echo "=== Update Complete ==="
    echo "New system: $(readlink -f /nix/var/nix/profiles/system)"
}

# Run main
main "$@"