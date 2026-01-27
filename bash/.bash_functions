# Create directory and cd into it
mkcd() {
    mkdir -p "$1" && cd "$1"
}

# Extract any archive type
extract() {
    if [ -f "$1" ]; then
        case "$1" in
            *.tar.bz2)   tar xjf "$1"     ;;
            *.tar.gz)    tar xzf "$1"     ;;
            *.bz2)       bunzip2 "$1"     ;;
            *.rar)       unrar e "$1"     ;;
            *.gz)        gunzip "$1"      ;;
            *.tar)       tar xf "$1"      ;;
            *.tbz2)      tar xjf "$1"     ;;
            *.tgz)       tar xzf "$1"     ;;
            *.zip)       unzip "$1"       ;;
            *.Z)         uncompress "$1"  ;;
            *.7z)        7z x "$1"        ;;
            *)           echo "'$1' cannot be extracted via extract()" ;;
        esac
    else
        echo "'$1' is not a valid file"
    fi
}

# Create timestamped backup of a file
backup() {
    if [ -f "$1" ]; then
        cp "$1"{,.backup-$(date +%Y%m%d-%H%M%S)}
        echo "Backed up: $1.backup-$(date +%Y%m%d-%H%M%S)"
    else
        echo "'$1' is not a valid file"
    fi
}

# Get public IP address
myip() {
    curl -s ifconfig.me
    echo ""
}

# Get local IP address(es)
localip() {
    ip addr show | grep "inet " | grep -v 127.0.0.1 | awk '{print $2}' | cut -d/ -f1
}

# Git clone and cd
gcl() {
    git clone "$1" && cd "$(basename "$1" .git)"
}