#!/bin/bash
set -e

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "Setting up dotfiles from $DOTFILES_DIR..."

# Stow packages that don't need special handling
cd "$DOTFILES_DIR"
stow -t ~ git
stow -t ~ nvim

# Handle shell config based on OS
if [[ "$OSTYPE" == "darwin"* ]]; then
    echo "Detected macOS, linking shell-config to ~/.zshrc"
    ln -sf "$DOTFILES_DIR/shell/shell-config" ~/.zshrc
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
    echo "Detected Linux, linking shell-config to ~/.bash_aliases"
    ln -sf "$DOTFILES_DIR/shell/shell-config" ~/.bash_aliases
else
    echo "Unknown OS: $OSTYPE"
    exit 1
fi

echo "Dotfiles setup complete!"
