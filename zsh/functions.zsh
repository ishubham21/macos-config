#!/usr/bin/env zsh
# =============================================================================
# functions.zsh - Advanced Custom Functions
# =============================================================================

# =============================================================================
# File & Directory Operations
# =============================================================================

# Create directory and cd into it
mkcd() {
    mkdir -p "$1" && cd "$1"
}

# Quick directory navigation (using functions instead of aliases)
up() { cd ..; }
up2() { cd ../..; }
up3() { cd ../../..; }
up4() { cd ../../../..; }

# Create and enter directory
take() {
    mkdir -p "$1" && cd "$1"
}

# Find and open file
fo() {
    local file
    file=$(fzf --query="$1" --select-1 --exit-0)
    [[ -n "$file" ]] && ${EDITOR:-code} "$file"
}

# Find and open directory
fd() {
    local dir
    dir=$(find ${1:-.} -path '*/\.*' -prune -o -type d -print 2> /dev/null | fzf +m)
    [[ -n "$dir" ]] && cd "$dir"
}

# Quick file search
ff() {
    find . -type f -name "*$1*" 2>/dev/null | head -20
}

# Search in files
grepf() {
    grep -r "$1" . --include="*.${2:-*}" 2>/dev/null | head -20
}

# =============================================================================
# Git Workflow Functions
# =============================================================================

# Quick git status with branch info
gst() {
    echo "=== Git Status ==="
    git status --short --branch
    echo ""
    echo "=== Recent Commits ==="
    git log --oneline -5
}

# Create and switch to new branch
gcb() {
    git checkout -b "$1"
}

# Quick commit with message
gcm() {
    git add . && git commit -m "$1"
}

# Push current branch
gps() {
    git push -u origin $(git branch --show-current)
}

# Pull latest changes
gpl() {
    git pull origin $(git branch --show-current)
}

# Merge and cleanup
gmerge() {
    local branch="$1"
    git checkout main && git pull origin main && git merge "$branch" && git branch -d "$branch"
}

# Interactive rebase
gri() {
    git rebase -i HEAD~${1:-3}
}

# Quick stash
gstash() {
    git stash push -m "$1"
}

# Apply last stash
gpop() {
    git stash pop
}

# Show git log with graph
glg() {
    git log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit
}

# Show file changes
gdiff() {
    git diff --name-only
}

# Quick add and commit
gac() {
    git add . && git commit -m "$1"
}

# =============================================================================
# Development Workflow Functions
# =============================================================================

# Start a new project
newproject() {
    local project_name="$1"
    local project_type="${2:-node}"
    
    mkdir "$project_name" && cd "$project_name"
    
    case "$project_type" in
        node|js)
            npm init -y
            echo "node_modules/\n.env\n*.log" > .gitignore
            ;;
        python|py)
            python3 -m venv venv
            echo "venv/\n__pycache__/\n*.pyc\n.env" > .gitignore
            ;;
        go)
            go mod init "$project_name"
            echo "*.exe\n*.dll\n*.so\n*.dylib\n*.test\n*.out\nvendor/" > .gitignore
            ;;
        *)
            echo "Unknown project type: $project_type"
            ;;
    esac
    
    git init
    git add .
    git commit -m "Initial commit"
    echo "✅ Project '$project_name' created successfully!"
}

# Quick server start
serve() {
    local port="${1:-3000}"
    if command -v python3 >/dev/null 2>&1; then
        python3 -m http.server "$port"
    elif command -v python >/dev/null 2>&1; then
        python -m SimpleHTTPServer "$port"
    else
        echo "Python not found. Please install Python to use this function."
    fi
}

# Quick port check
port() {
    lsof -i :"$1"
}

# Kill process on port
killport() {
    lsof -ti:"$1" | xargs kill -9
}

# =============================================================================
# System Utilities
# =============================================================================

# Show disk usage
dus() {
    du -sh * | sort -hr | head -10
}

# Show top processes
topcpu() {
    ps aux | sort -nrk 3,3 | head -10
}

# Show top memory usage
topmem() {
    ps aux | sort -nrk 4,4 | head -10
}

# Quick weather
weather() {
    curl -s "wttr.in/${1:-}"
}

# Quick IP info
ipinfo() {
    curl -s "ipinfo.io/${1:-}"
}

# =============================================================================
# Productivity Functions
# =============================================================================

# Create a todo list
todo() {
    local todo_file="${HOME}/.todo"
    case "$1" in
        add)
            echo "- [ ] $2" >> "$todo_file"
            echo "✅ Added: $2"
            ;;
        list|ls)
            if [[ -f "$todo_file" ]]; then
                cat "$todo_file"
            else
                echo "No todos found. Add one with: todo add 'your task'"
            fi
            ;;
        done)
            if [[ -f "$todo_file" ]]; then
                sed -i '' "s/- \[ \] $2/- [x] $2/" "$todo_file"
                echo "✅ Marked as done: $2"
            fi
            ;;
        clear)
            rm -f "$todo_file"
            echo "✅ Cleared all todos"
            ;;
        *)
            echo "Usage: todo {add|list|done|clear} [task]"
            ;;
    esac
}

# Quick note taking
note() {
    local note_file="${HOME}/notes/$(date +%Y-%m-%d).md"
    mkdir -p "${HOME}/notes"
    
    if [[ -n "$1" ]]; then
        echo "- $(date '+%H:%M'): $1" >> "$note_file"
        echo "✅ Note added: $1"
    else
        ${EDITOR:-code} "$note_file"
    fi
}

# Extract various archive formats
extract_file() {
    if [[ -f "$1" ]]; then
        case "$1" in
            *.tar.bz2)  tar xjf "$1" ;;
            *.tar.gz)   tar xzf "$1" ;;
            *.tar.xz)   tar xJf "$1" ;;
            *.bz2)      bunzip2 "$1" ;;
            *.rar)      unrar x "$1" ;;
            *.gz)       gunzip "$1" ;;
            *.tar)      tar xf "$1" ;;
            *.tbz2)     tar xjf "$1" ;;
            *.tgz)      tar xzf "$1" ;;
            *.zip)      unzip "$1" ;;
            *.Z)        uncompress "$1" ;;
            *.7z)       7z x "$1" ;;
            *)          echo "Error: '$1' cannot be extracted via extract()" ;;
        esac
    else
        echo "Error: '$1' is not a valid file"
    fi
}

# Find file and execute command on it
ff() {
    find . -type f -iname '*'"$1"'*' -exec "${2:-file}" {} \;
}

# Find directory
fd() {
    find . -type d -iname '*'"$1"'*'
}

# Find and grep
fgrep() {
    find . -type f -exec grep -l "$1" {} \;
}

# =============================================================================
# System Information
# =============================================================================

# System information function
sysinfo() {
    echo "=== System Information ==="
    echo "Hostname: $(hostname)"
    echo "Uptime: $(uptime)"
    echo "User: $(whoami)"
    echo "Date: $(date)"
    echo "Kernel: $(uname -sr)"
    
    if [[ "$OSTYPE" == darwin* ]]; then
        echo "macOS Version: $(sw_vers -productVersion)"
        echo "Model: $(sysctl -n hw.model)"
        echo "CPU: $(sysctl -n machdep.cpu.brand_string)"
        echo "Memory: $(( $(sysctl -n hw.memsize) / 1024**3 )) GB"
    fi
    
    echo "Disk Usage:"
    df -h / 2>/dev/null || df -h
}

# Process information
psgrep() {
    ps aux | grep -i "$1" | grep -v grep
}

# Memory usage by process
meminfo() {
    ps -eo pmem,pcpu,rss,vsize,args | sort -k 1 -rn | head -10
}

# =============================================================================
# Network Functions
# =============================================================================

# Port checker
portcheck() {
    local port=${1:-80}
    local host=${2:-localhost}
    
    if command -v nc >/dev/null 2>&1; then
        nc -zv "$host" "$port"
    elif command -v telnet >/dev/null 2>&1; then
        timeout 3 telnet "$host" "$port"
    else
        echo "Neither nc nor telnet available"
        return 1
    fi
}

# Get public IP with details
ipinfo() {
    curl -s "https://ipinfo.io/$1" | jq '.'
}

# Network scan
netscan() {
    local network=${1:-"192.168.1"}
    echo "Scanning network ${network}.1-254..."
    nmap -sn "${network}.1-254" 2>/dev/null | grep -E "Nmap scan report|MAC Address"
}

# DNS lookup with multiple record types
dnslookup() {
    local domain="$1"
    if [[ -z "$domain" ]]; then
        echo "Usage: dnslookup <domain>"
        return 1
    fi
    
    echo "=== DNS Lookup for $domain ==="
    echo "A Record:"     && dig +short A "$domain"
    echo "AAAA Record:"  && dig +short AAAA "$domain"
    echo "MX Record:"    && dig +short MX "$domain"
    echo "TXT Record:"   && dig +short TXT "$domain"
    echo "NS Record:"    && dig +short NS "$domain"
    echo "CNAME Record:" && dig +short CNAME "$domain"
}

# =============================================================================
# Development Functions
# =============================================================================

# Git functions
gclone() {
    git clone "$1" && cd "$(basename "$1" .git)"
}

# Create new branch and switch to it
gnb() {
    if [[ -z "$1" ]]; then
        echo "Usage: gnb <branch-name>"
        return 1
    fi
    git checkout -b "$1"
}

# Git commit with conventional commits
gconv() {
    local type="$1"
    local message="$2"
    
    if [[ -z "$type" || -z "$message" ]]; then
        echo "Usage: gconv <type> <message>"
        echo "Types: feat, fix, docs, style, refactor, test, chore"
        return 1
    fi
    
    git commit -m "${type}: ${message}"
}

# Initialize new project
initproject() {
    local name="$1"
    local type="${2:-node}"
    
    if [[ -z "$name" ]]; then
        echo "Usage: initproject <name> [type]"
        echo "Types: node, python, react, vue, go, rust"
        return 1
    fi
    
    mkdir -p "$name" && cd "$name"
    
    case "$type" in
        node)
            npm init -y
            echo "node_modules/\n.env\n*.log" > .gitignore
            ;;
        python)
            python3 -m venv venv
            echo "venv/\n__pycache__/\n*.pyc\n.env" > .gitignore
            echo "# $name\n\n## Setup\n\`\`\`bash\npython3 -m venv venv\nsource venv/bin/activate\npip install -r requirements.txt\n\`\`\`" > README.md
            touch requirements.txt
            ;;
        react)
            npx create-react-app . --template typescript
            ;;
        go)
            go mod init "$name"
            echo "# $name" > README.md
            echo "*.exe\n*.dll\n*.so\n*.dylib\n*.test\n*.out\nvendor/" > .gitignore
            ;;
    esac
    
    git init
    git add .
    git commit -m "feat: initial commit"
    echo "Project '$name' initialized with type '$type'"
}

# Docker helper functions
dexec() {
    local container="$1"
    shift
    docker exec -it "$container" "${@:-bash}"
}

dlogs() {
    local container="$1"
    docker logs -f "$container"
}

# =============================================================================
# Utility Functions
# =============================================================================

# Weather function with location
weather() {
    local location="${1:-Bengaluru}"
    curl -s "wttr.in/${location}?format=v2"
}

# QR code generator
qr() {
    local text="$1"
    if [[ -z "$text" ]]; then
        echo "Usage: qr <text>"
        return 1
    fi
    curl -s "https://qr-server.com/api/qr-server.php?size=200x200&data=${text}"
}

# URL shortener
shorten() {
    local url="$1"
    if [[ -z "$url" ]]; then
        echo "Usage: shorten <url>"
        return 1
    fi
    curl -s "https://is.gd/create.php?format=simple&url=${url}"
}

# Color palette
colors() {
    for i in {0..255}; do
        printf "\x1b[48;5;%sm%3d\e[0m " "$i" "$i"
        if (( i == 15 )) || (( i > 15 )) && (( (i-15) % 6 == 0 )); then
            printf "\n"
        fi
    done
}

# =============================================================================
# Performance & Monitoring
# =============================================================================

# Benchmark command execution
benchmark() {
    local cmd="$*"
    if [[ -z "$cmd" ]]; then
        echo "Usage: benchmark <command>"
        return 1
    fi
    
    echo "Benchmarking: $cmd"
    echo "Running 5 iterations..."
    
    for i in {1..5}; do
        echo -n "Run $i: "
        /usr/bin/time -p sh -c "$cmd" 2>&1 | grep real | awk '{print $2"s"}'
    done
}

# Monitor file changes
monitor() {
    local file="$1"
    if [[ -z "$file" ]]; then
        echo "Usage: monitor <file>"
        return 1
    fi
    
    if command -v fswatch >/dev/null 2>&1; then
        fswatch -o "$file" | xargs -n1 -I{} echo "File changed: $(date)"
    else
        echo "fswatch not installed. Install with: brew install fswatch"
    fi
}

# =============================================================================
# Text Processing
# =============================================================================

# Convert text to uppercase
upper() {
    echo "$*" | tr '[:lower:]' '[:upper:]'
}

# Convert text to lowercase
lower() {
    echo "$*" | tr '[:upper:]' '[:lower:]'
}

# Generate random string
randstr() {
    local length="${1:-16}"
    openssl rand -base64 "$((length * 3/4))" | tr -d "=+/" | cut -c1-"$length"
}

# URL encode
urlencode() {
    python3 -c "import urllib.parse; print(urllib.parse.quote('$1'))"
}

# URL decode
urldecode() {
    python3 -c "import urllib.parse; print(urllib.parse.unquote('$1'))"
}

# =============================================================================
# macOS Specific Functions
# =============================================================================

if [[ "$OSTYPE" == darwin* ]]; then
    # Toggle hidden files in Finder
    togglehidden() {
        local current=$(defaults read com.apple.finder AppleShowAllFiles 2>/dev/null)
        if [[ "$current" == "TRUE" ]]; then
            defaults write com.apple.finder AppleShowAllFiles -bool false
            echo "Hidden files are now hidden"
        else
            defaults write com.apple.finder AppleShowAllFiles -bool true
            echo "Hidden files are now visible"
        fi
        killall Finder
    }
    
    # Get app bundle ID
    bundleid() {
        osascript -e "id of app \"$1\""
    }
    
    # Eject all mounted volumes
    ejectall() {
        osascript -e 'tell application "Finder" to eject (every disk whose executable is true)'
    }
    
    # Lock screen
    lock() {
        /System/Library/CoreServices/Menu\ Extras/User.menu/Contents/Resources/CGSession -suspend
    }
fi

# =============================================================================
# Security Functions
# =============================================================================

# Generate SSH key
gensshkey() {
    local email="$1"
    local keytype="${2:-ed25519}"
    
    if [[ -z "$email" ]]; then
        echo "Usage: gensshkey <email> [keytype]"
        return 1
    fi
    
    ssh-keygen -t "$keytype" -C "$email" -f "$HOME/.ssh/id_${keytype}"
    echo "SSH key generated. Add to GitHub/GitLab:"
    cat "$HOME/.ssh/id_${keytype}.pub"
}

# Test SSL certificate
sslcheck() {
    local domain="$1"
    local port="${2:-443}"
    
    if [[ -z "$domain" ]]; then
        echo "Usage: sslcheck <domain> [port]"
        return 1
    fi
    
    echo | openssl s_client -connect "${domain}:${port}" 2>/dev/null | openssl x509 -noout -dates
}

# =============================================================================
# GPG Functions
# =============================================================================

# Enhanced GPG pinentry toggle with error handling
toggle_pinentry() {
    local gpg_dir="$HOME/.gnupg"
    local conf_file="$gpg_dir/gpg-agent.conf"
    
    # Create .gnupg directory if it doesn't exist
    [[ ! -d "$gpg_dir" ]] && mkdir -p "$gpg_dir" && chmod 700 "$gpg_dir"
    
    # Create gpg-agent.conf if it doesn't exist
    if [[ ! -f "$conf_file" ]]; then
        echo "pinentry-program /opt/homebrew/bin/pinentry-mac" > "$conf_file"
        chmod 600 "$conf_file"
    fi
    
    local current_pinentry
    current_pinentry=$(grep "pinentry-program" "$conf_file" 2>/dev/null | awk '{print $2}')
    
    if [[ $current_pinentry == *"pinentry-mac"* ]]; then
        echo "Switching to terminal pinentry (pinentry-curses)..."
        echo "pinentry-program /opt/homebrew/bin/pinentry-curses" > "$conf_file"
    else
        echo "Switching to graphical pinentry (pinentry-mac)..."
        echo "pinentry-program /opt/homebrew/bin/pinentry-mac" > "$conf_file"
    fi
    
    chmod 600 "$conf_file"
    gpgconf --kill gpg-agent
    gpgconf --launch gpg-agent
    echo "Pinentry toggled. Test with: echo 'test' | gpg --clearsign"
}

# =============================================================================
# Productivity Functions
# =============================================================================

# Quick note taking
note() {
    local note_dir="$HOME/notes"
    local note_file="$note_dir/$(date +%Y-%m-%d).md"
    
    [[ ! -d "$note_dir" ]] && mkdir -p "$note_dir"
    
    if [[ $# -eq 0 ]]; then
        $EDITOR "$note_file"
    else
        echo "$(date '+%H:%M:%S') - $*" >> "$note_file"
        echo "Note added to $(basename "$note_file")"
    fi
}

# Todo management
todo() {
    local todo_file="$HOME/.todo.txt"
    
    case "$1" in
        add|a)
            shift
            echo "[ ] $*" >> "$todo_file"
            echo "Todo added: $*"
            ;;
        list|l|"")
            if [[ -f "$todo_file" ]]; then
                cat -n "$todo_file"
            else
                echo "No todos found"
            fi
            ;;
        done|d)
            if [[ -n "$2" ]]; then
                sed -i.bak "${2}s/\[ \]/\[x\]/" "$todo_file" 2>/dev/null
                echo "Todo $2 marked as done"
            else
                echo "Usage: todo done <number>"
            fi
            ;;
        remove|rm)
            if [[ -n "$2" ]]; then
                sed -i.bak "${2}d" "$todo_file" 2>/dev/null
                echo "Todo $2 removed"
            else
                echo "Usage: todo remove <number>"
            fi
            ;;
        *)
            echo "Usage: todo [add <text>|list|done <number>|remove <number>]"
            ;;
    esac
}