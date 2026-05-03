# Resolve dotfiles directory dynamically (macOS: ~/.zshrc, Linux: ~/.bash_aliases)
if [ -n "${ZSH_VERSION:-}" ]; then
    bindkey -v
elif [ -n "${BASH_VERSION:-}" ]; then
    set -o vi
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
export EDITOR="nvim"

alias q="exit"
alias ":q"="exit"
alias c="clear"
alias cls="clear"
alias vps="ssh -tt nico@pujia"
alias fvps="mosh -p 60001 --server=/home/linuxbrew/.linuxbrew/bin/mosh-server nico@pujia"
alias config="nvim $DOTFILES_DIR/shell-config.sh"
alias cfg="config"
alias reload="source $DOTFILES_DIR/shell-config.sh"
alias nvimrc="nvim $DOTFILES_DIR/home/.config/nvim/init.lua"
alias g="git"
alias dk="docker"
alias oc="opencode"
alias claudio="claude --dangerously-skip-permissions"
alias kill-port='f(){ local pids; pids=$(lsof -ti:$1); if [[ $(echo $pids | wc -w) -eq 1 ]]; then kill $pids; echo "Killed PID $pids"; else echo "Multiple or no processes found: $pids"; fi; }; f'
alias killp="kill-port"
alias reload-tmux="tmux source-file ~/.tmux.conf"

_brewfile_add_entry() {
    local entry="$1"
    local brewfile="$DOTFILES_DIR/Brewfile"

    [[ -n "$DOTFILES_DIR" && -f "$brewfile" ]] || return
    grep -Fxq "$entry" "$brewfile" 2>/dev/null && return

    printf '%s\n' "$entry" >> "$brewfile"
    echo "Added to Brewfile: $entry"
}

_brewfile_record_install() {
    local entry_type="brew"
    local arg=""
    local skip_next=0

    for arg in "$@"; do
        case "$arg" in
            --cask|--casks)
                entry_type="cask"
                ;;
            --formula|--formulae)
                entry_type="brew"
                ;;
        esac
    done

    for arg in "$@"; do
        if [[ "$skip_next" -eq 1 ]]; then
            skip_next=0
            continue
        fi

        case "$arg" in
            --appdir)
                skip_next=1
                continue
                ;;
            --color|--display-times|--env|--fetch-HEAD|--formula|--formulae|--force-bottle|--HEAD|--ignore-dependencies|--interactive|--keep-tmp|--quiet|--verbose|--debug|--build-from-source|--build-bottle|--cask|--casks)
                continue
                ;;
            --appdir=*|--*)
                continue
                ;;
        esac

        _brewfile_add_entry "$entry_type \"$arg\""
    done
}

_brewfile_record_tap() {
    local arg=""

    for arg in "$@"; do
        [[ "$arg" == --* ]] && continue
        _brewfile_add_entry "tap \"$arg\""
    done
}

brew() {
    if [[ "$#" -eq 0 ]]; then
        command brew
        return $?
    fi

    local subcommand="$1"
    shift || true

    command brew "$subcommand" "$@"
    local brew_status=$?
    [[ "$brew_status" -eq 0 ]] || return "$brew_status"

    case "$subcommand" in
        install)
            _brewfile_record_install "$@"
            ;;
        tap)
            _brewfile_record_tap "$@"
            ;;
    esac

    return "$brew_status"
}

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
