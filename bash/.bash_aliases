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
alias gd='git diff'
alias gco='git checkout'
alias gb='git branch'

# Clipboard (Linux)
if command -v xclip &> /dev/null; then
    alias pbcopy='xclip -selection clipboard'
    alias pbpaste='xclip -selection clipboard -o'
fi

# ============= Modern CLI Tools =============
# bat (better cat with syntax highlighting)
if command -v batcat &> /dev/null; then
    alias cat='batcat --style=auto --paging=never'
    alias ccat='/usr/bin/cat'  # original cat if needed
fi

# eza (better ls with icons and git)
if command -v eza &> /dev/null; then
    alias ls='eza --group-directories-first'
    alias ll='eza -lah --group-directories-first --git'
    alias la='eza -a --group-directories-first'
    alias lt='eza -T --level=2 --group-directories-first'  # tree view
    alias lls='/usr/bin/ls'  # original ls if needed
fi