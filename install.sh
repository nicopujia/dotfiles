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

version_gt() {
    local IFS=.
    local left=($1)
    local right=($2)
    local i
    local max_len=${#left[@]}

    if (( ${#right[@]} > max_len )); then
        max_len=${#right[@]}
    fi

    for ((i = 0; i < max_len; i++)); do
        local left_part=${left[i]:-0}
        local right_part=${right[i]:-0}

        if (( 10#$left_part > 10#$right_part )); then
            return 0
        fi

        if (( 10#$left_part < 10#$right_part )); then
            return 1
        fi
    done

    return 1
}

prune_agent_browser_browsers() {
    local browsers_dir="$HOME/.agent-browser/browsers"
    local dirs=()
    local browser_names=()
    local dir entry browser_name version
    local known_name latest_version latest_dir
    local found_name removed_any=0

    if [[ ! -d "$browsers_dir" ]]; then
        return
    fi

    while IFS= read -r -d '' dir; do
        dirs+=("$dir")
    done < <(find "$browsers_dir" -mindepth 1 -maxdepth 1 -type d -print0)

    if (( ${#dirs[@]} == 0 )); then
        return
    fi

    echo "Pruning old agent-browser browser binaries..."

    for dir in "${dirs[@]}"; do
        entry=${dir##*/}
        browser_name=${entry%-*}

        if [[ "$browser_name" == "$entry" ]]; then
            continue
        fi

        found_name=0
        for known_name in "${browser_names[@]}"; do
            if [[ "$known_name" == "$browser_name" ]]; then
                found_name=1
                break
            fi
        done

        if (( ! found_name )); then
            browser_names+=("$browser_name")
        fi
    done

    for browser_name in "${browser_names[@]}"; do
        latest_version=
        latest_dir=

        for dir in "${dirs[@]}"; do
            entry=${dir##*/}

            if [[ ${entry%-*} != "$browser_name" ]]; then
                continue
            fi

            version=${entry##*-}

            if [[ -z "$latest_version" ]] || version_gt "$version" "$latest_version"; then
                latest_version=$version
                latest_dir=$dir
            fi
        done

        for dir in "${dirs[@]}"; do
            entry=${dir##*/}

            if [[ ${entry%-*} != "$browser_name" || "$dir" == "$latest_dir" ]]; then
                continue
            fi

            rm -rf "$dir"
            removed_any=1
            echo "  Removed $entry"
        done
    done

    if (( ! removed_any )); then
        echo "  No old browser binaries to prune"
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

if ! command -v agent-browser >/dev/null 2>&1; then
    echo "Installing agent-browser..."
    bun install -g agent-browser
fi

echo "Ensuring agent-browser browser binaries are installed..."
agent-browser install
prune_agent_browser_browsers

echo "Dotfiles setup complete!"
