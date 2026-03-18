# ============= Initialization =============
# ble.sh
[[ $- == *i* ]] && source -- ~/.local/share/blesh/ble.sh --attach=none

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

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
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# ============= pnpm =============
export PNPM_HOME="$HOME/.local/share/pnpm"
[[ ":$PATH:" != *":$PNPM_HOME:"* ]] && export PATH="$PNPM_HOME:$PATH"

# ============= SSH Agent =============
# Custom SSH agent management for persistent agent across terminal sessions.
# This ensures a single SSH agent is reused instead of spawning multiple agents.
# Useful when system-level SSH agent management is not available.
# Reuse existing SSH agent or start a new one
SSH_ENV="$HOME/.ssh/agent-env"

start_ssh_agent() {
    ssh-agent | sed 's/^echo/#echo/' > "${SSH_ENV}"
    chmod 600 "${SSH_ENV}"
    . "${SSH_ENV}" > /dev/null
}

if [ -f "${SSH_ENV}" ]; then
    . "${SSH_ENV}" > /dev/null
    # Check if agent is still running
    if ! kill -0 "$SSH_AGENT_PID" 2>/dev/null; then
        start_ssh_agent
    fi
else
    start_ssh_agent
fi

# Load SSH keys from ~/.bash_personal if needed
# Example in ~/.bash_personal:
#   ssh-add ~/.ssh/id_ed25519 2>/dev/null

# ============= Prompt =============
eval "$(starship init bash)"

# ============= zoxide =============
if command -v zoxide &> /dev/null; then
    eval "$(zoxide init bash)"
fi

# ============= Personal Configuration =============
[ -f ~/.bash_personal ] && . ~/.bash_personal

# ============= ble.sh Attach =============
[[ ! ${BLE_VERSION-} ]] || ble-attach