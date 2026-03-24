# Dotfiles

Managed with [GNU Stow](https://www.gnu.org/software/stow/).

## Quick Start

```bash
git clone https://github.com/nicopujia/dotfiles.git ~/dotfiles
cd ~/dotfiles
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
export LINEAR_API_KEY="..."
export CLAUDE_CODE_OAUTH_TOKEN="..."
```

The shell config automatically sources `~/.env` if it exists.
