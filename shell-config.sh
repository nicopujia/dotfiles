# Resolve dotfiles directory dynamically (macOS: ~/.zshrc, Linux: ~/.bash_aliases)
if [ -h ~/.zshrc ]; then
    export DOTFILES_DIR="$(cd "$(dirname "$(readlink ~/.zshrc)")" && pwd)"
elif [ -h ~/.bash_aliases ]; then
    export DOTFILES_DIR="$(cd "$(dirname "$(readlink ~/.bash_aliases)")" && pwd)"
fi

export PATH="/opt/homebrew/opt/ruby/bin:$PATH"
export PATH="$BUN_INSTALL/bin:$PATH"
export NVM_DIR="$HOME/.nvm"
export BUN_INSTALL="$HOME/.bun"
export LDFLAGS="-L/opt/homebrew/opt/ruby/lib"
export CPPFLAGS="-I/opt/homebrew/opt/ruby/include"

alias q="exit"
alias ":q"="exit"
alias c="clear"
alias vps="ssh -X nico@pujia"
alias fvps="mosh -p 60001 --server=/home/linuxbrew/.linuxbrew/bin/mosh-server nico@pujia"
alias config="nvim $DOTFILES_DIR/shell-config.sh"
alias cfg="config"
alias reload="source $DOTFILES_DIR/shell-config.sh"
alias nvimrc="nvim $DOTFILES_DIR/home/.config/nvim/init.lua"
alias g="git"
alias dk="docker"
alias oc="EDITOR=nvim opencode"
alias claudio="claude --dangerously-skip-permissions"
alias kill-port='f(){ local pids; pids=$(lsof -ti:$1); if [[ $(echo $pids | wc -w) -eq 1 ]]; then kill $pids; echo "Killed PID $pids"; else echo "Multiple or no processes found: $pids"; fi; }; f'
alias killp="kill-port"
alias bat="batcat"

# bun completions
[ -s "$BUN_INSTALL/_bun" ] && source "$BUN_INSTALL/_bun"

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
