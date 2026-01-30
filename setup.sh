#!/bin/bash
set -euo pipefail

# Dotfiles setup script
# Usage:
#   Fresh install:    curl -fsSL <raw-url>/setup.sh | bash
#   Existing repo:    ./setup.sh

DOTFILES_REPO="https://github.com/stricklin/dotfiles.git"
DOTFILES_DIR="$HOME/dotfiles"

echo "==> Dotfiles setup"

# Detect if we're running from the repo or standalone
if [[ -f "$(dirname "$0")/.chezmoi.toml.tmpl" ]]; then
    DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"
    echo "    Running from existing repo: $DOTFILES_DIR"
else
    # Clone if needed
    if [[ ! -d "$DOTFILES_DIR" ]]; then
        echo "==> Cloning dotfiles repo..."
        git clone "$DOTFILES_REPO" "$DOTFILES_DIR"
    else
        echo "    Dotfiles already at $DOTFILES_DIR"
    fi
fi

# Clean up old broken symlinks in home directory
echo "==> Cleaning up broken symlinks..."
find "$HOME" -maxdepth 1 -type l ! -exec test -e {} \; -print -delete 2>/dev/null || true

# Install chezmoi if not present
if ! command -v chezmoi &>/dev/null; then
    echo "==> Installing chezmoi..."
    sh -c "$(curl -fsLS get.chezmoi.io)" -- -b "$HOME/.local/bin"
    export PATH="$HOME/.local/bin:$PATH"
else
    echo "    chezmoi already installed"
fi

# Link dotfiles as chezmoi source
CHEZMOI_SOURCE="$HOME/.local/share/chezmoi"
if [[ -L "$CHEZMOI_SOURCE" ]]; then
    # Already a symlink, check if correct
    if [[ "$(readlink "$CHEZMOI_SOURCE")" != "$DOTFILES_DIR" ]]; then
        echo "==> Updating chezmoi source link..."
        rm "$CHEZMOI_SOURCE"
        ln -s "$DOTFILES_DIR" "$CHEZMOI_SOURCE"
    else
        echo "    chezmoi source already linked"
    fi
elif [[ -d "$CHEZMOI_SOURCE" ]]; then
    echo "    chezmoi source exists at $CHEZMOI_SOURCE (not a symlink)"
else
    echo "==> Linking dotfiles as chezmoi source..."
    mkdir -p "$(dirname "$CHEZMOI_SOURCE")"
    ln -s "$DOTFILES_DIR" "$CHEZMOI_SOURCE"
fi

# Initialize chezmoi (will prompt for name/email if not configured)
if [[ ! -f "$HOME/.config/chezmoi/chezmoi.toml" ]]; then
    echo "==> Initializing chezmoi..."
    chezmoi init
else
    echo "    chezmoi already initialized"
fi

# Apply chezmoi
echo "==> Applying dotfiles..."
chezmoi apply

echo "==> Done! Restart your shell or run: source ~/.zshrc"
