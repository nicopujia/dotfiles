#!/bin/bash
set -e

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

FORCE=false
for arg in "$@"; do
    case $arg in
        --force)
            FORCE=true
            shift
            ;;
    esac
done

echo "Setting up dotfiles from $DOTFILES_DIR..."

STOW_CMD="stow"
if [ "$FORCE" = true ]; then
    echo "Force mode enabled - will override existing files"
    STOW_CMD="stow --adopt"
fi

# Stow packages that don't need special handling
cd "$DOTFILES_DIR"
$STOW_CMD -t ~ git
$STOW_CMD -t ~ nvim
$STOW_CMD -t ~ opencode

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
