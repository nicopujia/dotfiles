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

load_homebrew() {
    local brew_bin=""

    for candidate in /opt/homebrew/bin/brew /usr/local/bin/brew /home/linuxbrew/.linuxbrew/bin/brew; do
        if [[ -x "$candidate" ]]; then
            brew_bin="$candidate"
            break
        fi
    done

    if [[ -n "$brew_bin" ]]; then
        eval "$("$brew_bin" shellenv)"
    fi
}

ensure_homebrew() {
    load_homebrew

    if command -v brew >/dev/null 2>&1; then
        return
    fi

    require_cmd curl "Install curl before running this setup."

    echo "Installing Homebrew..."
    NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

    load_homebrew
    require_cmd brew "Homebrew installation completed, but brew is not available on PATH."
}

install_uv_tools() {
    if [[ ! -f "$DOTFILES_DIR/uv-tools.txt" ]]; then
        return
    fi

    echo "Installing uv tools..."
    while IFS= read -r tool; do
        [[ -z "$tool" || "$tool" == \#* ]] && continue
        uv tool install "$tool"
    done < "$DOTFILES_DIR/uv-tools.txt"
}

echo "Setting up dotfiles from $DOTFILES_DIR..."

cd "$DOTFILES_DIR"

ensure_homebrew

echo "Installing Homebrew packages..."
brew bundle --file "$DOTFILES_DIR/Brewfile"

echo "Checking required setup binaries..."
require_cmd stow "Install GNU Stow before running this setup."
require_cmd bun "Install Bun before running this setup."
require_cmd uvx "Install uv before running this setup."
require_cmd uv "Install uv before running this setup."

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

install_uv_tools

if [[ -f "$HOME/.bun/install/global/package.json" ]]; then
    echo "Installing Bun global packages..."
    bun install --cwd "$HOME/.bun/install/global"
fi

echo "Ensuring agent-browser browser binaries are installed..."
agent-browser install
uv run --no-project "$DOTFILES_DIR/home/.config/shared/agent-browser-prune.py"

echo "Dotfiles setup complete!"
