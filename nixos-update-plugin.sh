#!/usr/bin/env bash
# NixOS Update Plugin
# This script automates the process of updating your NixOS system
# It handles committing changes, testing builds, and applying updates

set -e  # Exit on any error

echo "=== NixOS Update Plugin ==="

# Function to check if we're in the right directory
check_environment() {
    if [[ ! -f "flake.nix" ]]; then
        echo "Error: This doesn't appear to be a NixOS flake directory"
        exit 1
    fi
    
    if [[ ! -d ".git" ]]; then
        echo "Error: This directory is not a git repository"
        exit 1
    fi
}

# Function to get current status
get_status() {
    echo "Current system status:"
    echo "System generation: $(readlink -f /nix/var/nix/profiles/system)"
    echo "Git status:"
    git status --short
    echo ""
}

# Function to check for dirty working directory
check_dirty() {
    if ! git diff-index --quiet HEAD -- 2>/dev/null; then
        echo "Warning: Working directory has uncommitted changes"
        echo "These will be committed with the update"
    fi
}

# Function to update flake inputs
update_flake() {
    echo "Updating flake inputs..."
    nix flake update --flake .
    echo "Flake inputs updated"
}

# Function to commit changes
commit_changes() {
    echo "Committing changes..."
    # Add all relevant files
    git add flake.lock flake.nix 2>/dev/null || true
    
    # Add any other files that might be relevant
    git add aspects/ 2>/dev/null || true
    
    # Commit with a descriptive message
    git commit -m "build(flake): update flake inputs and dependencies" 2>/dev/null || {
        echo "No changes to commit"
    }
    echo "Changes committed"
}

# Function to test build
test_build() {
    echo "Testing build with antigravity (if available)..."
    
    if command -v antigravity &> /dev/null; then
        echo "Running antigravity test build..."
        antigravity --test-build
        if [ $? -eq 0 ]; then
            echo "Antigravity test build successful"
            return 0
        else
            echo "Antigravity test build failed"
            return 1
        fi
    else
        echo "antigravity not found, proceeding with nixos-rebuild test..."
        # Test build with nixos-rebuild
        echo "Running nixos-rebuild test build..."
        sudo nixos-rebuild test --flake .#nixos-gaming 2>/dev/null
        if [ $? -eq 0 ]; then
            echo "Test build successful"
            return 0
        else
            echo "Test build failed"
            return 1
        fi
    fi
}

# Function to apply update
apply_update() {
    echo "Applying system update..."
    sudo nixos-rebuild switch --flake .#nixos-gaming
    if [ $? -eq 0 ]; then
        echo "System update applied successfully!"
        return 0
    else
        echo "System update failed"
        return 1
    fi
}

# Function to show what would be updated
show_update_summary() {
    echo "Update Summary:"
    echo "Current system: $(readlink -f /nix/var/nix/profiles/system)"
    echo "Flake inputs will be updated"
    echo "Dependencies will be refreshed"
    echo ""
}

# Main execution
main() {
    echo "Starting NixOS Update Process"
    echo ""
    
    check_environment
    get_status
    check_dirty
    show_update_summary
    
    # Prompt for confirmation
    read -p "Do you want to proceed with the update? (y/N): " -n 1 -r
    echo ""
    
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "Update cancelled"
        exit 0
    fi
    
    echo "=== Starting Update Process ==="
    
    # Update flake inputs
    update_flake
    
    # Commit changes
    commit_changes
    
    # Test build
    if test_build; then
        # Apply update
        apply_update
    else
        echo "Update process aborted due to test failure"
        exit 1
    fi
    
    echo ""
    echo "=== Update Complete ==="
    echo "Current system: $(readlink -f /nix/var/nix/profiles/system)"
}

# Run main function
main "$@"