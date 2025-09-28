export ZSH="$HOME/.oh-my-zsh"

plugins=(
  1password
  alias-finder
  ansible
  argocd
  aws
  brew
  cabal
  colored-man-pages
  command-not-found
  common-aliases
  docker
  docker-compose
  extract
  git
  gradle
  helm
  history-substring-search
  k9s
  macos
  mvn
  nvm
  pip
  python
  sbt
  sdk
  starship
  systemd
  terraform
  thefuck
  tmux
  vscode
  zsh-interactive-cd
  zsh-navigation-tools
)

export ZSH_TMUX_AUTOSTART=true

if [[ "$(uname)" =~ Darwin ]]; then
  alias tailscale="/Applications/Tailscale.app/Contents/MacOS/Tailscale"
  export SSH_AUTH_SOCK=~/Library/Group\ Containers/2BUA8C4S2C.com.1password/t/agent.sock
fi

zstyle ':omz:plugins:alias-finder' autoload yes # disabled by default
zstyle ':omz:plugins:alias-finder' longer yes # disabled by default
zstyle ':omz:plugins:alias-finder' cheaper yes # disabled by default

zstyle ':omz:plugins:nvm' autoload yes
zstyle ':omz:plugins:nvm' silent-autoload yes

zstyle ':completion:*' menu select

source $ZSH/oh-my-zsh.sh

alias sshlist='sudo lsof -i -n | grep ssh'

# Get bundle id
getappid() {
    osascript -e "id of app \"$1\""
}

# Find and kill process by name
killbyname() {
    ps aux | grep "$1" | grep -v grep | awk '{print $2}' | xargs kill -9
}

# Docker cleanup function
docker_cleanup() {
    echo "Cleaning up Docker..."
    docker system prune -af
    docker volume prune -f
    echo "Docker cl—eanup complete!"
}

clip () {
    if [[ "$(uname)" =~ Darwin ]]; then 
	pbcopy 
    else 
	xclip -sel clip
    fi
}

# SDKMAN!
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"

eval "$(pyenv init --path)"
eval "$(pyenv virtualenv-init -)"

