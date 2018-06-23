# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
  export ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load. Optionally, if you set this to "random"
# it'll load a random theme each time that oh-my-zsh is loaded.
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
# muse
ZSH_THEME="sunrise"

# Uncomment the following line to disable auto-setting terminal title.
DISABLE_AUTO_TITLE="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
HIST_STAMPS="mm/dd/yyyy"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git cargo common-aliases docker encode64 gradle mvn npm cabal wd)

source $ZSH/oh-my-zsh.sh

# User configuration

# You may need to manually set your language environment
export LANG=en_US.UTF-8

#Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vim'
else
  export EDITOR='vim'
fi


# ------------------
# Menu autocomplete|
# ------------------
  setopt menucomplete
  zstyle ':completion:*' menu select=1 _complete _ignored _approximate

# ---------------------
# Correct program name|
# ---------------------
  setopt correct

# -----------
# Function for extract arch
# -----------

if test -t 1; then # if terminal
    ncolors=$(which tput > /dev/null && tput colors) # supports color
    if test -n "$ncolors" && test $ncolors -ge 8; then
        termcols=$(tput cols)
        red="$(tput setaf 1)"
        normal="$(tput sgr0)"
        green="$(tput setaf 2)"
    fi
fi


extract () {
  if [ -f $1 ] ; then
    case $1 in
      *.tar.bz2) tar xvjf $1   ;;
      *.tar.gz)  tar xvzf $1   ;;
      *.tar.xz)  tar xvfJ $1   ;;
      *.bz2)     bunzip2 $1    ;;
      *.rar)     unrar x $1    ;;
      *.gz)      gunzip $1     ;;
      *.tar)     tar xvf $1    ;;
      *.tbz2)    tar xvjf $1   ;;
      *.tgz)     tar xvzf $1   ;;
      *.zip)     unzip $1      ;;
      *.Z)       uncompress $1 ;;
      *.7z)      7z x $1       ;;
      *)         echo "'$1' cannot be extracted via >extract<" ;;
    esac
  else
    echo "'$1' is not a valid file"
  fi
}

# -----------
# Function for git
# -----------


alias githr='git reset --hard HEAD'

future-commit () {
    git commit -m $1 --date "$(date -d +$2hours)"
}

gitname () {
    gitconfig 'name' $1
}

gitemail () {
    gitconfig 'email' $1
}

gitpep () {
    gitname 'PepRoll'
    gitemail 'peproll@protonmail.com'
}

gitconfig () {
    case $1 in
        name)
            if [[ -n $2 ]]; then
                git config user.name "$2"
            else
                name=$(git config user.name)
                echo "$name"
            fi
            ;;
        email)
            if [[ -n $2 ]]; then
                git config user.email "$2"
            else
                email=$(git config user.email)
                echo "$email"
            fi
            ;;
        *)
            echo 'Not implemented case!'
    esac
}

vpn () {
    if (systemctl -q is-active openvpn)
    then
	systemctl stop openvpn
	echo "OpenVPN stopped"
    else
	systemctl start openvpn
	echo "OpenVPN started"
    fi
}

# Work

if [ -f ~/.work/init.sh ]; then
    source ~/.work/init.sh
fi

if [ -f ~/Go ]; then
    `mkdir ~/Go`
fi

export GOPATH="$HOME/Go"
export PATH="$PATH:$GOPATH/bin"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

export PATH="$PATH:$HOME/.rvm/bin:$HOME/.local/bin"
