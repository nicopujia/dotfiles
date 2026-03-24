# Dotfiles

Managed with [GNU Stow](https://www.gnu.org/software/stow/).

## Quick Start

```bash
git clone https://github.com/nicopujia/dotfiles.git
cd dotfiles
./install.sh
```

## Structure

```
.
├── git/           → ~/.gitconfig
├── nvim/          → ~/.config/nvim/
├── shell/         → ~/.zshrc (macOS) or ~/.bash_aliases (Linux)
└── install.sh     # Sets everything up
```

## Secrets

Create `~/.env` for private keys (not tracked):

```bash
# Add your API keys here
export API_KEY="your-key-here"
export OAUTH_TOKEN="your-token-here"
```

The shell config automatically sources `~/.env` if it exists.
