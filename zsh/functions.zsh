#!/usr/bin/env zsh

up() { cd ..; }
up2() { cd ../..; }
up3() { cd ../../..; }
up4() { cd ../../../..; }

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

psgrep() {
    ps aux | grep -i "$1" | grep -v grep
}

meminfo() {
    ps -eo pmem,pcpu,rss,vsize,args | sort -k 1 -rn | head -10
}

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

ipinfo() {
    curl -s "https://ipinfo.io/$1" | jq '.'
}

netscan() {
    local network=${1:-"192.168.1"}
    echo "Scanning network ${network}.1-254..."
    nmap -sn "${network}.1-254" 2>/dev/null | grep -E "Nmap scan report|MAC Address"
}

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

gclone() {
    git clone "$1" && cd "$(basename "$1" .git)"
}

gnb() {
    if [[ -z "$1" ]]; then
        echo "Usage: gnb <branch-name>"
        return 1
    fi
    git checkout -b "$1"
}

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

dexec() {
    local container="$1"
    shift
    docker exec -it "$container" "${@:-bash}"
}

dlogs() {
    local container="$1"
    docker logs -f "$container"
}

qr() {
    local text="$1"
    if [[ -z "$text" ]]; then
        echo "Usage: qr <text>"
        return 1
    fi
    curl -s "https://qr-server.com/api/qr-server.php?size=200x200&data=${text}"
}

shorten() {
    local url="$1"
    if [[ -z "$url" ]]; then
        echo "Usage: shorten <url>"
        return 1
    fi
    curl -s "https://is.gd/create.php?format=simple&url=${url}"
}

colors() {
    for i in {0..255}; do
        printf "\x1b[48;5;%sm%3d\e[0m " "$i" "$i"
        if (( i == 15 )) || (( i > 15 )) && (( (i-15) % 6 == 0 )); then
            printf "\n"
        fi
    done
}

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

upper() {
    echo "$*" | tr '[:lower:]' '[:upper:]'
}

lower() {
    echo "$*" | tr '[:upper:]' '[:lower:]'
}

randstr() {
    local length="${1:-16}"
    openssl rand -base64 "$((length * 3/4))" | tr -d "=+/" | cut -c1-"$length"
}

urlencode() {
    python3 -c "import urllib.parse; print(urllib.parse.quote('$1'))"
}

urldecode() {
    python3 -c "import urllib.parse; print(urllib.parse.unquote('$1'))"
}

if [[ "$OSTYPE" == darwin* ]]; then
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
    
    bundleid() {
        osascript -e "id of app \"$1\""
    }
    
    ejectall() {
        osascript -e 'tell application "Finder" to eject (every disk whose executable is true)'
    }
    
    lock() {
        /System/Library/CoreServices/Menu\ Extras/User.menu/Contents/Resources/CGSession -suspend
    }
fi

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

sslcheck() {
    local domain="$1"
    local port="${2:-443}"
    
    if [[ -z "$domain" ]]; then
        echo "Usage: sslcheck <domain> [port]"
        return 1
    fi
    
    echo | openssl s_client -connect "${domain}:${port}" 2>/dev/null | openssl x509 -noout -dates
}

toggle_pinentry() {
    local gpg_dir="$HOME/.gnupg"
    local conf_file="$gpg_dir/gpg-agent.conf"
    
    [[ ! -d "$gpg_dir" ]] && mkdir -p "$gpg_dir" && chmod 700 "$gpg_dir"
    
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