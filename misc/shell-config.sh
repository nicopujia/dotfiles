# --- Get file's location ---
_dotfiles_shell_config="${BASH_SOURCE[0]:-${(%):-%N}}"
if [ -L "$_dotfiles_shell_config" ]; then
    _dotfiles_shell_config="$(readlink "$_dotfiles_shell_config")"
fi

# --- Variables ---
export DOTFILES_DIR="$(cd "$(dirname "$_dotfiles_shell_config")" && pwd)"
export DOTFILES_MISC_DIR="$DOTFILES_DIR"
export NVM_DIR="$HOME/.nvm"
export BUN_INSTALL="$HOME/.bun"
export PATH="/opt/homebrew/bin:/opt/homebrew/opt/ruby/bin:$BUN_INSTALL/bin:$PATH"
export LDFLAGS="-L/opt/homebrew/opt/ruby/lib"
export CPPFLAGS="-I/opt/homebrew/opt/ruby/include"

# --- Aliases ---
alias q="exit"
alias ":q"="exit"
alias c="clear"
alias cls="clear"
alias vps="ssh pujia"
alias fvps="mosh -p 60001 --server=/home/linuxbrew/.linuxbrew/bin/mosh-server nico@pujia"
alias config="vim $DOTFILES_DIR/shell-config.sh"
alias cfg="config"
alias reload="source $DOTFILES_DIR/shell-config.sh"
alias g="git"
alias dk="docker"
alias oc='EDITOR=vim OPENCODE_CONFIG_CONTENT="{ \"\$schema\": \"https://opencode.ai/config.json\", \"permission\": \"allow\" }" opencode'
alias cl="claude --dangerously-skip-permissions"
alias cx="codex --yolo"
alias kill-port='f(){ local pids; pids=$(lsof -ti:$1); if [[ $(echo $pids | wc -w) -eq 1 ]]; then kill $pids; echo "Killed PID $pids"; else echo "Multiple or no processes found: $pids"; fi; }; f'
alias killp="kill-port"
alias reload-tmux="tmux source-file ~/.tmux.conf"

# --- Patches ---
# bun completions
[ -n "${ZSH_VERSION:-}" ] && [ -s "$BUN_INSTALL/_bun" ] && source "$BUN_INSTALL/_bun"

# ghostty <> tmux patch
if [[ "$TERM_PROGRAM" == "ghostty" ]]; then
    export TERM=xterm-256color
fi

# API KEYS / OAUTH TOKENS - load from ~/.env (not tracked in git)
[ -f ~/.env ] && source ~/.env

# load nvm
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

# load nvm bash_completion
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# OS/Shell-specific configs
if [ -n "${ZSH_VERSION:-}" ]; then
    # --- Enable zoxide ---
    eval "$(zoxide init zsh)"

    # --- Vim mode for command line ---
    # Use zsh's vi-style line editor. This is shell editing, not full Vim.
    bindkey -v

    # Wait briefly after Esc so terminal escape sequences, like Delete, are recognized.
    export KEYTIMEOUT=10

    # Zed sends Delete as Esc [ 3 ~. Make it delete the character under the cursor
    # while typing, but leave normal mode alone so it stays vi-like.
    bindkey -M viins '^[[3~' delete-char

    # Make Backspace delete to the left while typing. In normal mode it keeps
    # zsh's default vi behavior.
    bindkey -M viins '^?' backward-delete-char

    # Change cursor shape when switching modes: block in normal mode, bar in insert mode.
    function zle-keymap-select {
        case "$KEYMAP" in
            vicmd) printf '\e[2 q' ;;
            *) printf '\e[6 q' ;;
        esac
    }
    zle -N zle-keymap-select

    # Start each prompt in insert mode's cursor shape.
    function zle-line-init {
        printf '\e[6 q'
    }
    zle -N zle-line-init

    # Reset cursor shape after accepting a command.
    function zle-line-finish {
        printf '\e[0 q'
    }
    zle -N zle-line-finish
elif [ -n "${BASH_VERSION:-}" ]; then
    # --- Enable zoxide ---
    eval "$(zoxide init bash)"
fi

if [[ "$OSTYPE" == "linux-gnu"* && -x /usr/bin/tmux ]]; then
    alias tmux="/usr/bin/tmux"
fi
