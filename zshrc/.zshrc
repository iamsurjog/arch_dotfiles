# zmodload zsh/zprof
# ----------------------------------------
# Environment & PATH Configuration
# ----------------------------------------
export XDG_CONFIG_HOME="$HOME/.config"
export GOBIN="$HOME/go/bin"
export VCPKG_ROOT="$HOME/.local/share/vcpkg"
export PYENV_ROOT="$HOME/.pyenv"

# Deduplicated and cleaned up PATH syntax
path=(
    $GOBIN
    $HOME/surjo/college/softwares
    $HOME/surjo/path
    $PYENV_ROOT/bin
    $HOME/.local/bin
    /opt/cuda/bin
    $path
)
export PATH

# ----------------------------------------
# Aliases
# ----------------------------------------
alias n2='NVIM_APPNAME=nvim2 nvim'
alias n='nvim'
alias l='eza -alh'
alias ls='eza -alh --icons --git'
alias i='yay -S'
alias s='yay -Ss'
alias q='yay -Qi'
alias bye='yay -Rns'
alias update='yay -Syu --disable-download-timeout'
alias py='python3'
alias venv='py -m venv ./.venv'
alias ..='z ..'
alias ...='z ../..'
alias c="printf '\ec'"
alias b='btop'
alias lg='lazygit'
alias bomba="df -h | grep 'Filesystem\|nvme'"
alias stats="journalctl -p 3 -xb"
alias ff="fastfetch"
alias :q="exit"
alias chungus="du -ha -d 1 | sort -h"
alias pdfy="unoconv -f pdf"
alias gremlin="JAVA_HOME=/usr/lib/jvm/java-11-openjdk gremlin"
alias napalm="rm -rf .next/ && npm run dev"
alias rd="rm -rf"
alias mntext="mount -o uid=$(id -u),gid=$(id -g)"

# ----------------------------------------
# Optimization & Completion System
# ----------------------------------------
ZSH_DISABLE_COMPFIX=true

# Add custom and system directories to fpath BEFORE compinit
fpath=(
    $ZSH/plugins/zsh-completions/src
    /usr/share/zsh/site-functions
    /usr/share/zsh/functions/Completion
    ~/
    $fpath
)

# Fixed compilation dump cache check (Checks if modified in the last 24 hours)
# autoload -Uz compinit
# if [[ -n ${ZDOTDIR:-$HOME}/.zcompdump(#qN.m-1) ]]; then
#     compinit -C
# else
#     compinit
# fi

source ~/.zsh-defer/zsh-defer.plugin.zsh

_lazy_compinit() {
  autoload -Uz compinit
  typeset -g _zcompdump="${ZDOTDIR:-$HOME}/.zcompdump"
  setopt LOCAL_OPTIONS EXTENDED_GLOB

  if [[ -n ${_zcompdump}(#qN.m-1) ]]; then
    compinit -C -d "$_zcompdump"
  else
    compinit -d "$_zcompdump"
  fi

  [[ ! "$_zcompdump.zwc" -nt "$_zcompdump" ]] && zcompile "$_zcompdump" 2>/dev/null &!
}

# Defers compinit until prompt is idle
zsh-defer _lazy_compinit

# Completion styles
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 
zstyle ':completion:*' menu select                       
zstyle ':completion:*' completer _complete _match _approximate
zstyle ':completion:*:match:*' original only
zstyle ':completion:*:approximate:*' max-errors 1 numeric

# ----------------------------------------
# Heavy CLI Tools Initializations (Optimized)
# ----------------------------------------
# [[ -d $PYENV_ROOT/bin ]] && eval "$(pyenv init - --no-rehash zsh)"
eval "$(zoxide init zsh)"
# eval "$(fnm env)"
eval "$(atuin init zsh)"
eval "$(oh-my-posh init zsh --config $HOME/.config/oh-my-posh/negligible.omp.json)"

# Bindkeys & Hooks
bindkey '^ ' autosuggest-accept

# ----------------------------------------
# Python Venv Auto-Activation Hook
# ----------------------------------------
python_venv() {
    if [[ -d ./.venv ]]; then
        source ./.venv/bin/activate >/dev/null 2>&1
    elif [[ -n "$VIRTUAL_ENV" ]]; then
        deactivate >/dev/null 2>&1
    fi
}
autoload -U add-zsh-hook
add-zsh-hook chpwd python_venv
python_venv # Run once on startup if terminal opens into a venv directory

# ----------------------------------------
# Plugins (Must be sourced at the absolute end)
# ----------------------------------------
[[ -f /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh ]] && source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
[[ -f /usr/share/zsh/plugins/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh ]] && source /usr/share/zsh/plugins/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh
eval "$(direnv hook zsh)"

# Vite+ bin (https://viteplus.dev)
. "$HOME/.vite-plus/env"
# zprof
