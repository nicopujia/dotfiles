# Dotfiles

## Quick Start

Prerrequisites: [GNU Stow](https://www.gnu.org/software/stow/), [bun](https://bun.sh), [uv](https://docs.astral.sh/uv/getting-started/installation)

```bash
git clone https://github.com/nicopujia/dotfiles.git
cd dotfiles
./install.sh
```

## Structure

```
.
├── install.sh               Sets everything up
├── shell-config.sh          → ~/.zshrc (macOS) or ~/.bash_aliases (Linux)
└── home/                    Stow package → symlinks to ~
    └── ...                  → ~/...
```

## Secrets

Create `~/.env` for private keys (not tracked):

```bash
# Add your API keys here
export API_KEY="your-key-here"
export OAUTH_TOKEN="your-token-here"
```

The shell config automatically sources `~/.env` if it exists.

## Workflow

**Files are symlinked** - edit in the repo, changes apply immediately:

```bash
nvim ~/dotfiles/shell-config.sh           # Edit shell config
nvim ~/dotfiles/home/.config/nvim/init.lua  # Edit nvim config
```

**Sync to another machine:**

```bash
cd ~/dotfiles && git pull
```

Python tooling for Zed and OpenCode is centralized in `home/.config/shared/`:

- `home/.config/shared/python-format.sh` keeps formatting behavior aligned
- `home/.config/shared/python-lsp.sh` keeps the Python LSP launcher aligned

**If you edited the live file directly** (e.g., `~/.zshrc`), copy changes back:

```bash
cp ~/.zshrc ~/dotfiles/shell-config.sh
cd ~/dotfiles && git diff && git commit -am "Update shell config"
```
