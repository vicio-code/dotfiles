# ============= Startup Profiling =============
# Enable with: BASH_STARTUP_DEBUG=1 bash
# Then check: /tmp/bash_startup.<PID>.log
if [[ "$BASH_STARTUP_DEBUG" == "1" ]]; then
    PS4='+ $BASH_SOURCE:$LINENO: '
    exec 3>&2 2>/tmp/bash_startup.$$.log
    set -x
fi

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# ============= Initialization =============
# ble.sh
[[ $- == *i* ]] && source -- ~/.local/share/blesh/ble.sh --attach=none

# ============= History =============
HISTCONTROL=ignoreboth:erasedups
HISTSIZE=10000
HISTFILESIZE=20000
HISTTIMEFORMAT="%F %T "
shopt -s histappend
shopt -s cmdhist

# ============= Shell Options =============
shopt -s checkwinsize
shopt -s autocd
shopt -s cdspell
shopt -s dirspell

# ============= Chroot Detection =============
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# ============= PATH =============
# fzf
if [[ -d ~/.fzf/bin ]]; then
    [[ ":$PATH:" != *":$HOME/.fzf/bin:"* ]] && export PATH="$HOME/.fzf/bin:$PATH"
fi

# zoxide
if [[ -d ~/.local/bin ]]; then
    [[ ":$PATH:" != *":$HOME/.local/bin:"* ]] && export PATH="$HOME/.local/bin:$PATH"
fi

# ============= ble.sh Configuration =============
if [[ ${BLE_VERSION-} ]]; then
    bleopt editor='vim'
    bleopt prompt_eol_mark=
fi

# ============= Less & Man Colors =============
if command -v batcat &> /dev/null; then
    # Use bat as man pager
    export MANPAGER="sh -c 'col -bx | batcat -l man -p'"
    export MANROFFOPT="-c"
else
    # Fallback to colored less
    export LESS_TERMCAP_mb=$'\e[1;32m'
    export LESS_TERMCAP_md=$'\e[1;32m'
    export LESS_TERMCAP_me=$'\e[0m'
    export LESS_TERMCAP_se=$'\e[0m'
    export LESS_TERMCAP_so=$'\e[01;33m'
    export LESS_TERMCAP_ue=$'\e[0m'
    export LESS_TERMCAP_us=$'\e[1;4;31m'
fi

# Less options
export LESS='-R -F -X -i -M'

# ============= Aliases & Functions =============
[ -f ~/.bash_aliases ] && . ~/.bash_aliases
[ -f ~/.bash_functions ] && . ~/.bash_functions

# ============= Bash Completion =============
if ! shopt -oq posix; then
    [ -f /usr/share/bash-completion/bash_completion ] && . /usr/share/bash-completion/bash_completion
fi

# ============= Node Version Manager =============
export NVM_DIR="$HOME/.nvm"

_nvm_lazy_load() {
    unset -f nvm node npm npx pnpm
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
    [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
}

nvm()  { _nvm_lazy_load; nvm  "$@"; }
node() { _nvm_lazy_load; node "$@"; }
npm()  { _nvm_lazy_load; npm  "$@"; }
npx()  { _nvm_lazy_load; npx  "$@"; }
pnpm() { _nvm_lazy_load; pnpm "$@"; }

# ============= pnpm =============
export PNPM_HOME="$HOME/.local/share/pnpm"
[[ ":$PATH:" != *":$PNPM_HOME:"* ]] && export PATH="$PNPM_HOME:$PATH"

# ============= Opencode =============
export EDITOR="code --wait"

# ============= SSH Agent =============
# SSH agent is managed per-machine via .bash_personal (keychain or ssh-agent).
# See .bash_personal.example for setup instructions.

# ============= Prompt =============
if command -v starship &> /dev/null; then
    _starship_cache="$HOME/.cache/starship_init.sh"
    _starship_ver="$HOME/.cache/starship_init.ver"
    if [[ ! -f "$_starship_cache" ]] || [[ "$(starship --version 2>/dev/null)" != "$(cat "$_starship_ver" 2>/dev/null)" ]]; then
        mkdir -p ~/.cache
        starship init bash > "$_starship_cache"
        starship --version > "$_starship_ver"
    fi
    source "$_starship_cache"
fi

# ============= zoxide =============
if command -v zoxide &> /dev/null; then
    _zoxide_cache="$HOME/.cache/zoxide_init.sh"
    _zoxide_ver="$HOME/.cache/zoxide_init.ver"
    if [[ ! -f "$_zoxide_cache" ]] || [[ "$(zoxide --version 2>/dev/null)" != "$(cat "$_zoxide_ver" 2>/dev/null)" ]]; then
        mkdir -p ~/.cache
        zoxide init bash > "$_zoxide_cache"
        zoxide --version > "$_zoxide_ver"
    fi
    source "$_zoxide_cache"
fi

# ============= Personal Configuration =============
[ -f ~/.bash_personal ] && . ~/.bash_personal

# ============= ble.sh Attach =============
[[ ! ${BLE_VERSION-} ]] || ble-attach

# Close profiling if enabled
if [[ "$BASH_STARTUP_DEBUG" == "1" ]]; then
    set +x
    exec 2>&3 3>&-
fi
# opencode
[[ ":$PATH:" != *":$HOME/.opencode/bin:"* ]] && export PATH="$HOME/.opencode/bin:$PATH"
