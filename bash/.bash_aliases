# Navigation shortcuts

alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'

# Better ls aliases
alias ll='ls -alF'    # Long format, all files, classify
alias la='ls -A'      # All files except . and ..
alias l='ls -CF'      # Column format, classify
alias lt='ls -alFtr'  # Long format, sorted by time (newest last)

# Safety nets - ask before overwriting
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'

# System information
alias df='df -h'      # Human-readable disk space
alias du='du -h'      # Human-readable disk usage
alias free='free -h'  # Human-readable memory

# Grep with color
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

# Miscellaneous
alias h='history'           # Shorter history command
alias c='clear'            # Shorter clear command
alias reload='exec bash'   # Reload bash config
alias path='echo -e ${PATH//:/\\n}'  # Show PATH, one entry per line

# Git aliases
alias gs='git status'
alias ga='git add'
alias gc='git commit'
alias gp='git push'
alias gl='git log --oneline --graph --decorate --all'
alias gd='git diff'
alias gco='git checkout'
alias gb='git branch'

# Docker
alias dc='docker-compose'
alias dps='docker ps'
alias di='docker images'
alias dex='docker exec -it'
alias dlog='docker logs -f'

# Kubernetes
alias k='kubectl'
alias kgp='kubectl get pods'
alias kgs='kubectl get services'
alias kgd='kubectl get deployments'
alias kdp='kubectl describe pod'
alias kl='kubectl logs -f'

# Clipboard (Linux)
alias pbcopy='xclip -selection clipboard'
alias pbpaste='xclip -selection clipboard -o'