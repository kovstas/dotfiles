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


if [[ "$(uname)" =~ Darwin ]]; then
  alias tailscale="/Applications/Tailscale.app/Contents/MacOS/Tailscale"
  export SSH_AUTH_SOCK=~/Library/Group\ Containers/2BUA8C4S2C.com.1password/t/agent.sock
else 
  export PATH="$PATH:/home/kovstas/.local/share/coursier/bin"
fi

export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"

eval "$(pyenv init --path)"

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

# ESP32 Init
alias get_idf='. $HOME/esp/esp-idf/export.sh > /dev/null 2>&1'

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
CONDA_EXE="$HOME/miniforge3/bin/conda"
__conda_setup="$($CONDA_EXE 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "$HOME/miniforge3/etc/profile.d/conda.sh" ]; then
        . "$HOME/miniforge3/etc/profile.d/conda.sh"
    else
        export PATH="$HOME/miniforge3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<


# >>> mamba initialize >>>
# !! Contents within this block are managed by 'mamba shell init' !!
export MAMBA_EXE="$HOME/miniforge3/bin/mamba";
export MAMBA_ROOT_PREFIX="$HOME/miniforge3";
__mamba_setup="$("$MAMBA_EXE" shell hook --shell zsh --root-prefix "$MAMBA_ROOT_PREFIX" 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__mamba_setup"
else
    alias mamba="$MAMBA_EXE"  # Fallback on help from mamba activate
fi
unset __mamba_setup
# <<< mamba initialize <<<

