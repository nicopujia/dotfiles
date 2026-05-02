# Dotfiles

## Quick Start

Prerequisite: `curl`.

The installer bootstraps [Homebrew](https://brew.sh) if it is missing. Homebrew then installs GNU Stow, Bun, uv, formulae, and casks from `Brewfile`.

```bash
git clone https://github.com/nicopujia/dotfiles.git
cd dotfiles
./install.sh
```

## Structure

```
.
├── install.sh               Sets everything up
├── Brewfile                 Homebrew formulae and casks
├── uv-tools.txt             uv-managed global tools
├── shell-config.sh          → ~/.zshrc (macOS) or ~/.bash_aliases (Linux)
└── home/                    Stow package → symlinks to ~
    └── ...                  → ~/...
```

## Packages

Machine-level packages are managed in three places:

- `Brewfile` controls Homebrew formulae and casks, including `bun` and `uv`
- `uv-tools.txt` controls global tools installed with `uv tool install`
- `home/.bun/install/global/package.json` controls global Bun packages

The shell config wraps `brew install` and `brew tap` so successful installs are appended to `Brewfile` automatically. Use `brew install --cask <app>` for casks so they are recorded as `cask` entries.

Repo-level tools such as test frameworks, formatters, and formatter plugins should live in the repo that uses them, not in these dotfiles.

Obsidian is installed as a cask, but Obsidian vault config is intentionally not tracked yet.

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
