#!/bin/bash

# Neovim Config Sync Script
# Syncs changes from ~/.config/nvim to ~/nvim-buga repository

set -e # Exit on any error

# Configuration
NVIM_CONFIG_DIR="$HOME/.config/nvim"
REPO_DIR="$HOME/nvim-buga"
COMMIT_MESSAGE="${1:-Update nvim configuration}"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
  echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
  echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
  echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
  echo -e "${RED}[ERROR]${NC} $1"
}

# Check if nvim config directory exists
if [ ! -d "$NVIM_CONFIG_DIR" ]; then
  print_error "Neovim config directory not found: $NVIM_CONFIG_DIR"
  exit 1
fi

# Check if repository directory exists
if [ ! -d "$REPO_DIR" ]; then
  print_error "Repository directory not found: $REPO_DIR"
  exit 1
fi

# Check if repo directory is a git repository
if [ ! -d "$REPO_DIR/.git" ]; then
  print_error "Repository directory is not a git repository: $REPO_DIR"
  exit 1
fi

print_status "Starting sync from $NVIM_CONFIG_DIR to $REPO_DIR"

# Change to repository directory
cd "$REPO_DIR"

# Copy configuration files
print_status "Copying configuration files..."

# Copy main config files
cp -r "$NVIM_CONFIG_DIR/lua" "$REPO_DIR/" 2>/dev/null || print_warning "No lua directory found"
cp "$NVIM_CONFIG_DIR/init.lua" "$REPO_DIR/" 2>/dev/null || print_warning "No init.lua found"

# Copy optional files if they exist
cp "$NVIM_CONFIG_DIR/lazy-lock.json" "$REPO_DIR/" 2>/dev/null || true
cp "$NVIM_CONFIG_DIR/stylua.toml" "$REPO_DIR/" 2>/dev/null || true
cp "$NVIM_CONFIG_DIR/.neoconf.json" "$REPO_DIR/" 2>/dev/null || true

print_success "Files copied successfully"

# Check if there are any changes
if git diff --quiet && git diff --cached --quiet; then
  print_warning "No changes detected in the repository"
  exit 0
fi

# Show what changed
print_status "Changes detected:"
git status --porcelain

# Add all changes
print_status "Adding changes to git..."
git add .

# Commit changes
print_status "Committing changes..."
git commit -m "$COMMIT_MESSAGE"

print_success "Changes committed with message: '$COMMIT_MESSAGE'"

# Ask if user wants to push
read -p "Do you want to push to remote? (y/N): " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
  print_status "Pushing to remote..."
  git push
  print_success "Changes pushed to remote repository"
else
  print_warning "Changes committed locally but not pushed to remote"
  echo "To push later, run: cd $REPO_DIR && git push"
fi

print_success "Sync completed!"
