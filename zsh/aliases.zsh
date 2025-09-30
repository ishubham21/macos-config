#!/usr/bin/env zsh

alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias ~='cd ~'
alias -- -='cd -'

if command -v exa >/dev/null 2>&1; then
    alias ls='exa --group-directories-first'
    alias ll='exa -l --group-directories-first --time-style=long-iso'
    alias la='exa -la --group-directories-first --time-style=long-iso'
    alias lt='exa --tree --level=2 --group-directories-first'
    alias ltr='exa --tree --recurse --group-directories-first'
else
    alias ls='ls --color=auto'
    alias ll='ls -alF --color=auto'
    alias la='ls -A --color=auto'
    alias l='ls -CF --color=auto'
fi

alias cp='cp -i'
alias mv='mv -i'
alias ln='ln -i'
alias mkdir='mkdir -pv'
alias md='mkdir -pv'
alias rmdir='rmdir -v'

alias h='history'
alias j='jobs -l'
alias c='clear'
alias cls='clear'
alias ps='ps auxf'
alias psg='ps aux | grep -v grep | grep -i -e VSZ -e'
alias top='top -o cpu'
alias htop='htop -C'

if command -v dust >/dev/null 2>&1; then
    alias du='dust'
else
    alias du='du -h'
fi
alias df='df -h'
alias free='free -h'
alias ping='ping -c 5'
alias myip='curl -s ipinfo.io/ip'
alias localip="ifconfig | grep 'inet ' | grep -v 127.0.0.1 | cut -d\  -f2"

alias grep='grep --color=auto'
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'

if command -v rg >/dev/null 2>&1; then
    alias grep='rg'
    alias search='rg -i'
fi

if command -v fd >/dev/null 2>&1; then
    alias find='fd'
fi

if command -v bat >/dev/null 2>&1; then
    alias cat='bat --style=plain --paging=never'
    alias less='bat --style=plain'
fi

alias g='git'
alias gs='git status -sb'
alias gss='git status'
alias gl='git log --oneline --graph --decorate --all'
alias glog='git log --graph --pretty=format:"%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset" --abbrev-commit'
alias gd='git diff'
alias gdc='git diff --cached'
alias gdh='git diff HEAD'

alias gb='git branch'
alias gba='git branch -a'
alias gbd='git branch -d'
alias gbD='git branch -D'
alias gco='git checkout'
alias gcb='git checkout -b'
alias gcm='git checkout main || git checkout master'
alias gcd='git checkout develop'

alias ga='git add'
alias gaa='git add .'
alias gap='git add -p'
alias gc='git commit'
alias gcm='git commit -m'
alias gca='git commit -a'
alias gcam='git commit -am'
alias gcf='git commit --fixup'
alias gce='git commit --amend'
alias gcne='git commit --amend --no-edit'

alias gf='git fetch'
alias gfa='git fetch --all'
alias gp='git push'
alias gpo='git push origin'
alias gpu='git push -u origin'
alias gpf='git push --force-with-lease'
alias gpl='git pull'
alias gpr='git pull --rebase'

alias gst='git stash'
alias gstp='git stash pop'
alias gstl='git stash list'
alias gstd='git stash drop'

alias grh='git reset HEAD'
alias grhh='git reset HEAD --hard'
alias gundo='git reset HEAD~1 --mixed'

alias gclean='git clean -fd'
alias gignore='git update-index --assume-unchanged'
alias gunignore='git update-index --no-assume-unchanged'

if command -v docker >/dev/null 2>&1; then
    alias d='docker'
    alias dc='docker-compose'
    alias dcu='docker-compose up -d'
    alias dcd='docker-compose down'
    alias dcl='docker-compose logs -f'
    alias dps='docker ps'
    alias dpsa='docker ps -a'
    alias di='docker images'
    alias drmi='docker rmi'
    alias dprune='docker system prune -af'
    alias dstop='docker stop $(docker ps -aq)'
    alias drm='docker rm $(docker ps -aq)'
fi

if command -v kubectl >/dev/null 2>&1; then
    alias k='kubectl'
    alias kgp='kubectl get pods'
    alias kgs='kubectl get services'
    alias kgd='kubectl get deployments'
    alias kgn='kubectl get nodes'
    alias kd='kubectl describe'
    alias kl='kubectl logs'
    alias ke='kubectl exec -it'
    alias kctx='kubectl config current-context'
    alias kns='kubectl config set-context --current --namespace'
fi

alias ni='npm install'
alias nis='npm install --save'
alias nid='npm install --save-dev'
alias nig='npm install --global'
alias nt='npm test'
alias nr='npm run'
alias ns='npm start'
alias nb='npm run build'
alias nf='npm audit fix'

if command -v pnpm >/dev/null 2>&1; then
    alias pn='pnpm'
    alias pni='pnpm install'
    alias pna='pnpm add'
    alias pnd='pnpm add -D'
    alias pnr='pnpm run'
    alias pnt='pnpm test'
    alias pns='pnpm start'
    alias pnb='pnpm build'
fi

if command -v yarn >/dev/null 2>&1; then
    alias y='yarn'
    alias ya='yarn add'
    alias yad='yarn add --dev'
    alias yr='yarn run'
    alias ys='yarn start'
    alias yb='yarn build'
    alias yt='yarn test'
fi

alias py='python3'
alias pip='pip3'
alias venv='python3 -m venv'
alias activate='source ./venv/bin/activate'

alias dj='python manage.py'
alias djr='python manage.py runserver'
alias djm='python manage.py migrate'
alias djmm='python manage.py makemigrations'
alias djs='python manage.py shell'

alias be='bundle exec'
alias bi='bundle install'
alias bu='bundle update'

if command -v psql >/dev/null 2>&1; then
    alias pgstart='brew services start postgresql'
    alias pgstop='brew services stop postgresql'
    alias pgrestart='brew services restart postgresql'
fi

if command -v mysql >/dev/null 2>&1; then
    alias mystart='brew services start mysql'
    alias mystop='brew services stop mysql'
    alias myrestart='brew services restart mysql'
fi

if command -v redis-cli >/dev/null 2>&1; then
    alias redisstart='brew services start redis'
    alias redisstop='brew services stop redis'
    alias redisrestart='brew services restart redis'
fi

alias serve='python3 -m http.server'
alias serve8000='python3 -m http.server 8000'
alias serve3000='python3 -m http.server 3000'

if command -v php >/dev/null 2>&1; then
    alias phpserve='php -S localhost:8000'
fi

alias chrome='/Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome'
alias firefox='/Applications/Firefox.app/Contents/MacOS/firefox'
alias safari='open -a Safari'

if command -v brew >/dev/null 2>&1; then
    alias brewup='brew update && brew upgrade && brew cleanup'
    alias brewinfo='brew leaves | xargs brew desc --eval-all'
    alias brewsize='brew list --formula | xargs -n1 -P8 -I {} \
        sh -c "brew info {} | egrep \"[0-9]* files, \" | sed \"s/^.*[0-9]* files, *\([0-9.]*\)/\1/g\" | \
        sed \"s/\(.*\)/\1 {}/g\"" | sort -gr'
fi

if [[ "$OSTYPE" == darwin* ]]; then
    alias flushdns='sudo dscacheutil -flushcache && sudo killall -HUP mDNSResponder'
    alias showfiles='defaults write com.apple.finder AppleShowAllFiles YES && killall Finder'
    alias hidefiles='defaults write com.apple.finder AppleShowAllFiles NO && killall Finder'
fi

if command -v gpg >/dev/null 2>&1; then
    alias gpglist='gpg --list-secret-keys --keyid-format LONG'
    alias gpgexport='gpg --armor --export'
fi

alias sshconfig='$EDITOR ~/.ssh/config'
alias sshkey='cat ~/.ssh/id_ed25519.pub | pbcopy && echo "SSH key copied to clipboard"'

if command -v openssl >/dev/null 2>&1; then
    alias genpass='openssl rand -base64 32'
fi

alias extract='extract_file'
alias tarzip='tar -czf'
alias tarunzip='tar -xzf'

if command -v convert >/dev/null 2>&1; then
    alias imgoptimize='convert -strip -interlace Plane -gaussian-blur 0.05 -quality 85'
fi

if command -v ffmpeg >/dev/null 2>&1; then
    alias mp4towebm='ffmpeg -i'
fi

alias zshrc='$EDITOR ~/.zshrc'
alias zshreload='source ~/.zshrc'
alias hosts='sudo $EDITOR /etc/hosts'
alias sshconf='$EDITOR ~/.ssh/config'
alias gitconf='$EDITOR ~/.gitconfig'

alias dotfiles='cd $DOTFILES'
alias dots='cd $DOTFILES'
alias editdots='$EDITOR $DOTFILES'

alias weather='curl wttr.in'
alias moon='curl wttr.in/moon'
alias please='sudo'
alias pls='sudo'
alias fucking='sudo'
alias timer='echo "Timer started. Stop with Ctrl-D." && date && time cat && date'

if [[ "$OSTYPE" == darwin* ]]; then
    alias o='open'
    alias oo='open .'
    alias finder='open -a Finder'
    alias copy='pbcopy'
    alias paste='pbpaste'
    alias ql='qlmanage -p'
    
    
    alias osupdate='sudo softwareupdate -i -a'
    alias hidedesktop='defaults write com.apple.finder CreateDesktop -bool false && killall Finder'
    alias showdesktop='defaults write com.apple.finder CreateDesktop -bool true && killall Finder'
fi

if command -v terraform >/dev/null 2>&1; then
    alias tf='terraform'
    alias tfi='terraform init'
    alias tfp='terraform plan'
    alias tfa='terraform apply'
    alias tfd='terraform destroy'
    alias tfv='terraform validate'
    alias tff='terraform fmt'
fi

if command -v aws >/dev/null 2>&1; then
    alias awsp='aws --profile'
    alias awswho='aws sts get-caller-identity'
fi

if command -v ansible >/dev/null 2>&1; then
    alias ap='ansible-playbook'
    alias av='ansible-vault'
    alias ag='ansible-galaxy'
fi

alias code.='code .'
alias subl.='subl .'
alias atom.='atom .'

alias dsclean='find . -name ".DS_Store" -type f -delete'
alias nodemodclean='find . -name "node_modules" -type d -exec rm -rf {} +'
alias xcclean='rm -rf ~/Library/Developer/Xcode/DerivedData/*'

alias -g ...='../..'
alias -g ....='../../..'
alias -g .....='../../../..'
alias -g H='| head'
alias -g T='| tail'
alias -g G='| grep'
alias -g L='| less'
alias -g M='| more'
alias -g LL='2>&1 | less'
alias -g CA='2>&1 | cat -A'
alias -g NE='2> /dev/null'
alias -g NUL='> /dev/null 2>&1'

alias -s txt=$EDITOR
alias -s md=$EDITOR
alias -s json=$EDITOR
alias -s js=$EDITOR
alias -s ts=$EDITOR
alias -s html=$EDITOR
alias -s css=$EDITOR
alias -s tar='tar -tf'
alias -s gz='tar -tzf'
alias -s zip='unzip -l'

if [[ "$OSTYPE" == darwin* ]]; then
    alias -s http='open'
    alias -s https='open'
fi

alias c='clear'
alias h='history'
alias j='jobs'
alias f='fg'
alias k='kill'
alias e='${EDITOR:-code}'
alias v='${EDITOR:-code}'
alias o='open'
alias p='pwd'

alias n='note'
alias todo='todo'
alias weather='weather'
alias ip='ipinfo'
alias serve='serve'
alias port='port'
alias killport='killport'
alias dus='dus'
alias topcpu='topcpu'
alias topmem='topmem'

alias ff='ff'
alias fd='fd'
alias fo='fo'
alias grepf='grepf'
alias take='take'
alias mkcd='mkcd'

alias gst='gst'
alias gcb='gcb'
alias gcm='gcm'
alias gps='gps'
alias gpl='gpl'
alias gmerge='gmerge'
alias gri='gri'
alias gstash='gstash'
alias gpop='gpop'
alias glg='glg'
alias gdiff='gdiff'
alias gac='gac'

alias newproject='newproject'