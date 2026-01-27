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
if [[ -d ~/.fzf/bin ]]; then
    export PATH="$HOME/.fzf/bin:$PATH"
fi
# zoxide
if [[ -d ~/.local/bin ]]; then
    export PATH="$HOME/.local/bin:$PATH"
fi

# ============= ble.sh Configuration =============
if [[ ${BLE_VERSION-} ]]; then
    bleopt editor='vim'
fi

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
SSH_ENV="$HOME/.ssh/agent-environment"

function start_agent {
    echo "Initialising new SSH agent..."
    /usr/bin/ssh-agent | sed 's/^echo/#echo/' > "${SSH_ENV}"
    echo succeeded
    chmod 600 "${SSH_ENV}"
    . "${SSH_ENV}" > /dev/null
    /usr/bin/ssh-add;
}

if [ -f "${SSH_ENV}" ]; then
    . "${SSH_ENV}" > /dev/null
    ps -ef | grep ${SSH_AGENT_PID} | grep ssh-agent$ > /dev/null || {
        start_agent;
    }
else
    start_agent;
fi

# ============= Prompt =============
eval "$(starship init bash)"

# ============= zoxide =============
if command -v zoxide &> /dev/null; then
    eval "$(zoxide init bash)"
fi

# ============= ble.sh Attach =============
[[ ! ${BLE_VERSION-} ]] || ble-attach