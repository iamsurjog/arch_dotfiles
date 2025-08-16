# [[ $TERM != "screen" ]] && exec tmux
# if command -v tmux &> /dev/null && [ -n "$PS1" ] && [[ ! "$TERM" =~ screen ]] && [[ ! "$TERM" =~ tmux ]] && [ -z "$TMUX" ]; then
#   exec tmux
# fi
# if [ "$TMUX" = "" ]; then tmux new \; set-option destroy-unattached; fi

fastfetch
# if command -v tmux &> /dev/null && [ -n "$PS1" ] && [[ ! "$TERM" =~ screen ]] && [[ ! "$TERM" =~ tmux ]] && [ -z "$TMUX" ]; then
#   exec tmux
# fi

alias n='nvim'
alias l='eza -al'
alias i='yay -S'
alias s='yay -Ss'
alias q='yay -Q'
alias bye='yay -R'
alias update='yay -Syu --disable-download-timeout'
alias py='python3'
alias venv='py -m venv ./.venv'
alias ..='z ..'
alias ...='z ../..'
alias c='clear'
alias b='btop'
alias lg='lazygit'
alias bomba="df -h | grep 'Filesystem\|nvme' "
alias stats="journalctl -p 3 -xb"
alias ff="fastfetch"
alias :q="exit"
alias chungus="du -shc * | sort -h"

# ----------------------------------------
# PATH Variables
# ----------------------------------------
export PATH="/home/randomguy/surjo/college/softwares:$PATH"
export PATH="/home/randomguy/surjo/path:$PATH"
export XDG_CONFIG_HOME="$HOME/.config"

# ----------------------------------------
# Completion System Setup (Optimized)
# ----------------------------------------

# Add zsh-completions and system completions to fpath
fpath=(
    $ZSH/plugins/zsh-completions/src
    /usr/share/zsh/site-functions
    /usr/share/zsh/functions/Completion
    $fpath
)

# Disable compfix security checks (optional, but speeds up)
ZSH_DISABLE_COMPFIX=true

# Only regenerate compdump if older than 1 day
autoload -Uz compinit
if [[ ! -f ${ZDOTDIR:-$HOME}/.zcompdump || ${ZDOTDIR:-$HOME}/.zcompdump -ot /bin/date ]]; then
    compinit -C
else
    compinit -C
fi

# Completion styles
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' # Case-insensitive matching
zstyle ':completion:*' menu select                        # Interactive menu selection
zstyle ':completion:*' completer _complete _match _approximate
zstyle ':completion:*:match:*' original only
zstyle ':completion:*:approximate:*' max-errors 1 numeric

# ----------------------------------------
# Plugin Sourcing (after compinit)
# ----------------------------------------

# Fast syntax highlighting (keep at end)
source /usr/share/zsh/plugins/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh

# Autosuggestions
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh

# ----------------------------------------
# Python venv auto-activation
# ----------------------------------------
python_venv() {
    MYVENV=./.venv
    [[ -d $MYVENV ]] && source $MYVENV/bin/activate >/dev/null 2>&1
    [[ ! -d $MYVENV ]] && deactivate >/dev/null 2>&1
}

#!/bin/bash


autoload -U add-zsh-hook
add-zsh-hook chpwd python_venv

python_venv

export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init - zsh)"

eval "$(zoxide init zsh)"

eval "$(oh-my-posh init zsh --config $HOME/.config/oh-my-posh/negligible.omp.json)"

eval "$(fnm env)"

eval "$(atuin init zsh)"
