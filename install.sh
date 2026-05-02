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

ensure_cmux_omo_config() {
    local config_dir="$HOME/.cmuxterm/omo-config"
    local source_config="$HOME/.config/opencode/oh-my-openagent.json"
    local target_config="$config_dir/oh-my-openagent.json"

    if [[ ! -e "$source_config" ]]; then
        echo "Skipping cmux OMO config link; missing $source_config"
        return
    fi

    mkdir -p "$config_dir"

    if [[ -L "$target_config" && "$(readlink "$target_config")" == "$source_config" ]]; then
        echo "cmux OMO config already linked"
        return
    fi

    if [[ -e "$target_config" || -L "$target_config" ]]; then
        mv "$target_config" "$target_config.bak-$(date +%Y%m%d-%H%M%S)"
    fi

    ln -s "$source_config" "$target_config"
    echo "Linked cmux OMO config to $source_config"
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

install_cmux_omo_shim() {
    local shim_dir="$HOME/.cmuxterm/omo-bin"
    local shim="$shim_dir/opencode"

    echo "Installing cmux omo opencode config shim..."
    mkdir -p "$shim_dir"
    cat > "$shim" <<'EOF'
#!/bin/sh
set -eu

self_dir="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"
real_opencode=""
old_ifs=$IFS
IFS=:
for path_dir in $PATH; do
  [ -z "$path_dir" ] && path_dir=.
  [ "$path_dir" = "$self_dir" ] && continue
  candidate="$path_dir/opencode"
  if [ -x "$candidate" ]; then
    real_opencode="$candidate"
    break
  fi
done
IFS=$old_ifs

if [ -z "$real_opencode" ]; then
  echo "cmux omo: opencode not found in PATH" >&2
  exit 127
fi

user_config="${XDG_CONFIG_HOME:-$HOME/.config}/opencode"
omo_config="${OPENCODE_CONFIG_DIR:-$HOME/.cmuxterm/omo-config}"

link_config() {
  src="$1"
  dst="$2"
  if [ -f "$src" ]; then
    rm -f "$dst"
    ln -s "$src" "$dst"
  fi
}

if [ -d "$user_config" ]; then
  mkdir -p "$omo_config"
  link_config "$user_config/oh-my-openagent.json" "$omo_config/oh-my-openagent.json"
  link_config "$user_config/oh-my-openagent.jsonc" "$omo_config/oh-my-openagent.jsonc"
  link_config "$user_config/oh-my-opencode.json" "$omo_config/oh-my-opencode.json"
  link_config "$user_config/oh-my-opencode.jsonc" "$omo_config/oh-my-opencode.jsonc"
fi

exec "$real_opencode" "$@"
EOF
    chmod +x "$shim"
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

ensure_cmux_omo_config

find "$DOTFILES_DIR/home/.config/shared" -type f -name "*.sh" -exec chmod +x {} \;

install_cmux_omo_shim

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

echo "Dotfiles setup complete!"
