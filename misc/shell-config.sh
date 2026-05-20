# Resolve dotfiles directory dynamically (macOS: ~/.zshrc, Linux: ~/.bash_aliases)
if [ -n "${ZSH_VERSION:-}" ]; then
    eval "$(zoxide init zsh)"
elif [ -n "${BASH_VERSION:-}" ]; then
    eval "$(zoxide init bash)"
fi

_dotfiles_shell_config="${BASH_SOURCE[0]:-${(%):-%N}}"
if [ -L "$_dotfiles_shell_config" ]; then
    _dotfiles_shell_config="$(readlink "$_dotfiles_shell_config")"
fi
export DOTFILES_DIR="$(cd "$(dirname "$_dotfiles_shell_config")" && pwd)"
export DOTFILES_MISC_DIR="$DOTFILES_DIR"

export NVM_DIR="$HOME/.nvm"
export BUN_INSTALL="$HOME/.bun"
export PATH="/opt/homebrew/bin:/opt/homebrew/opt/ruby/bin:$BUN_INSTALL/bin:$PATH"
export LDFLAGS="-L/opt/homebrew/opt/ruby/lib"
export CPPFLAGS="-I/opt/homebrew/opt/ruby/include"

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
if [[ "$OSTYPE" == "linux-gnu"* && -x /usr/bin/tmux ]]; then
    alias tmux="/usr/bin/tmux"
fi
alias kill-port='f(){ local pids; pids=$(lsof -ti:$1); if [[ $(echo $pids | wc -w) -eq 1 ]]; then kill $pids; echo "Killed PID $pids"; else echo "Multiple or no processes found: $pids"; fi; }; f'
alias killp="kill-port"
alias reload-tmux="tmux source-file ~/.tmux.conf"

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
