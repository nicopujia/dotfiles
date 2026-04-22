#!/bin/bash
set -e

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

require_cmd() {
    if ! command -v "$1" >/dev/null 2>&1; then
        echo "Missing required command: $1"
        echo "$2"
        exit 1
    fi
}

echo "Setting up dotfiles from $DOTFILES_DIR..."

cd "$DOTFILES_DIR"

# Remove existing symlinks/files to avoid conflicts
# Process directories bottom-up so directory symlinks are removed
# before we try to remove their contents (avoids deleting repo files
# through directory-level symlinks created by a previous stow run)
echo "Removing existing symlinks..."
if [[ -d "$HOME/.agents" && ! -L "$HOME/.agents" ]]; then
    rm -rf "$HOME/.agents"
    echo "  Removed existing $HOME/.agents directory"
fi
find home -mindepth 1 -type d | sort -r | while read -r dir; do
    target="$HOME/${dir#home/}"
    if [[ -L "$target" ]]; then
        rm -f "$target"
        echo "  Removed dir symlink $target"
    fi
done
find home -type f | while read -r file; do
    target="$HOME/${file#home/}"
    if [[ -e "$target" || -L "$target" ]]; then
        rm -f "$target"
        echo "  Removed $target"
    fi
done

stow -t ~ home

find "$DOTFILES_DIR/home/.config/shared" -type f -name "*.sh" -exec chmod +x {} \;

# Handle shell config based on OS
if [[ "$OSTYPE" == "darwin"* ]]; then
    echo "Detected macOS, linking shell-config.sh to ~/.zshrc"
    rm -f ~/.zshrc
    ln -sf "$DOTFILES_DIR/shell-config.sh" ~/.zshrc
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
    echo "Detected Linux, linking shell-config.sh to ~/.bash_aliases"
    rm -f ~/.bash_aliases
    ln -sf "$DOTFILES_DIR/shell-config.sh" ~/.bash_aliases
else
    echo "Unknown OS: $OSTYPE"
    exit 1
fi

echo "Checking required binaries for skills and MCPs..."
require_cmd bun "Install Bun from https://bun.sh before running this setup."
require_cmd uvx "Install uv from https://docs.astral.sh/uv/getting-started/installation/ before running this setup."
require_cmd uv "Install uv from https://docs.astral.sh/uv/getting-started/installation/ before running this setup."

if ! command -v agent-browser >/dev/null 2>&1; then
    echo "Installing agent-browser..."
    bun install -g agent-browser
fi

echo "Ensuring agent-browser browser binaries are installed..."
agent-browser install
uv run --no-project "$DOTFILES_DIR/home/.config/shared/agent-browser-prune.py"

echo "Dotfiles setup complete!"
