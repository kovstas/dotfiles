#!/usr/bin/env bash
set -euo pipefail

# ======================================================================
# Minimal Developer CLI Environment Setup
# For Linux servers (Debian/Ubuntu)
# Installs CLI tools only, no dotfile modifications
# ======================================================================

echo "Updating package index..."
sudo apt update -y
sudo apt upgrade -y

echo "Installing base packages..."
sudo apt install -y \
  build-essential \
  curl \
  wget \
  git \
  unzip \
  zip \
  software-properties-common \
  ca-certificates \
  gnupg \
  lsb-release \
  locales

# Ensure UTF-8 locale is available
sudo locale-gen en_US.UTF-8

# ----------------------------------------------------------------------
# Core Development Tools
# ----------------------------------------------------------------------

sudo apt install -y \
  ansible \
  awscli \
  docker.io \
  docker-compose \
  coreutils \
  jq \
  htop \
  tree \
  tmux \
  sqlite3 \
  ripgrep \
  sshpass \
  fzf \
  neovim \
  python3 \
  python3-pip \
  openjdk-17-jdk \
  maven \
  lua5.4 \
  nodejs \
  npm \
  postgresql-client \
  unzip

# ----------------------------------------------------------------------
# GitHub CLI
# ----------------------------------------------------------------------

if ! command -v gh >/dev/null 2>&1; then
  echo "Installing GitHub CLI..."
  curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | \
    sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg
  sudo chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg
  echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] \
    https://cli.github.com/packages stable main" | \
    sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null
  sudo apt update
  sudo apt install -y gh
fi

# ----------------------------------------------------------------------
# HashiCorp Tools (Terraform, TFLint)
# ----------------------------------------------------------------------

# ----------------------------------------------------------------------
# HashiCorp Tools (Terraform, TFLint)
# ----------------------------------------------------------------------

if ! command -v terraform >/dev/null 2>&1; then
  echo "Installing Terraform..."
  curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
  echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] \
    https://apt.releases.hashicorp.com $(lsb_release -cs) main" | \
    sudo tee /etc/apt/sources.list.d/hashicorp.list
  sudo apt update
  sudo apt install -y terraform
fi

if ! command -v tflint >/dev/null 2>&1; then
  echo "Installing TFLint..."
  if snap list tflint >/dev/null 2>&1; then
    echo "TFLint already installed via snap."
  elif command -v snap >/dev/null 2>&1; then
    sudo snap install tflint
  else
    echo "Snap not available, installing TFLint from GitHub release..."
    TFLINT_VERSION=$(curl -s https://api.github.com/repos/terraform-linters/tflint/releases/latest | grep -Po '"tag_name": "\K.*?(?=")')
    curl -Lo tflint.zip "https://github.com/terraform-linters/tflint/releases/download/${TFLINT_VERSION}/tflint_linux_amd64.zip"
    unzip tflint.zip -d tflint_bin
    sudo install tflint_bin/tflint /usr/local/bin/
    rm -rf tflint.zip tflint_bin
  fi
fi

# ----------------------------------------------------------------------
# Kubernetes Tools (kubectl, helm, k9s)
# ----------------------------------------------------------------------

if ! command -v kubectl >/dev/null 2>&1; then
  echo "Installing kubectl..."
  curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
  sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
  rm kubectl
fi

if ! command -v helm >/dev/null 2>&1; then
  echo "Installing Helm..."
  curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash
fi

if ! command -v k9s >/dev/null 2>&1; then
  echo "Installing K9s..."
  curl -sS https://webinstall.dev/k9s | bash
fi

# ----------------------------------------------------------------------
# pyenv + pyenv-virtualenv
# ----------------------------------------------------------------------

if [ ! -d "$HOME/.pyenv" ]; then
  echo "Installing pyenv and pyenv-virtualenv..."
  curl https://pyenv.run | bash
fi

# ----------------------------------------------------------------------
# Node Version Manager (nvm)
# ----------------------------------------------------------------------

if [ ! -d "$HOME/.nvm" ]; then
  echo "Installing NVM..."
  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash
fi

# ----------------------------------------------------------------------
# Oh My Zsh (no config changes)
# ----------------------------------------------------------------------

if ! command -v zsh >/dev/null 2>&1; then
  echo "Installing Zsh..."
  sudo apt install -y zsh
fi

if [ ! -d "$HOME/.oh-my-zsh" ]; then
  echo "Installing Oh My Zsh..."
  RUNZSH=no CHSH=no KEEP_ZSHRC=yes \
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

# Plugins (not sourced automatically)
ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"
[ ! -d "${ZSH_CUSTOM}/plugins/zsh-autosuggestions" ] && \
  git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM}/plugins/zsh-autosuggestions
[ ! -d "${ZSH_CUSTOM}/plugins/zsh-syntax-highlighting" ] && \
  git clone https://github.com/zsh-users/zsh-syntax-highlighting ${ZSH_CUSTOM}/plugins/zsh-syntax-highlighting

# ----------------------------------------------------------------------
# Starship Prompt (no shell init modification)
# ----------------------------------------------------------------------

if ! command -v starship >/dev/null 2>&1; then
  echo "Installing Starship prompt..."
  curl -sS https://starship.rs/install.sh | sh -s -- -y
fi

# ----------------------------------------------------------------------
# TheFuck (Python command corrector)
# ----------------------------------------------------------------------

pip3 install --user thefuck

# ----------------------------------------------------------------------
# LazyGit
# ----------------------------------------------------------------------

if ! command -v lazygit >/dev/null 2>&1; then
  echo "Installing LazyGit..."
  LAZYGIT_VERSION=$(curl -s https://api.github.com/repos/jesseduffield/lazygit/releases/latest | grep -Po '"tag_name": "\K.*?(?=")')
  curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/download/${LAZYGIT_VERSION}/lazygit_${LAZYGIT_VERSION#v}_Linux_x86_64.tar.gz"
  tar xf lazygit.tar.gz lazygit
  sudo install lazygit /usr/local/bin
  rm lazygit lazygit.tar.gz
fi

# ----------------------------------------------------------------------
# Dive (Docker image analyzer)
# ----------------------------------------------------------------------

if ! command -v dive >/dev/null 2>&1; then
  echo "Installing Dive..."
  DIVE_VERSION=$(curl -s https://api.github.com/repos/wagoodman/dive/releases/latest | grep -Po '"tag_name": "\K.*?(?=")')
  curl -Lo dive.deb "https://github.com/wagoodman/dive/releases/download/${DIVE_VERSION}/dive_${DIVE_VERSION#v}_linux_amd64.deb"
  sudo apt install -y ./dive.deb
  rm dive.deb
fi

# ----------------------------------------------------------------------
# Coursier (manages Scala, sbt, scalacli, etc.)
# ----------------------------------------------------------------------

if ! command -v cs >/dev/null 2>&1; then
  echo "Installing Coursier (Scala toolchain manager)..."
  curl -fLo cs https://github.com/coursier/coursier/releases/latest/download/cs-x86_64-pc-linux.gz
  gunzip cs-x86_64-pc-linux.gz
  mv cs-x86_64-pc-linux cs
  chmod +x cs
  sudo mv cs /usr/local/bin/
fi

# Optional: install Scala + sbt through coursier
if command -v cs >/dev/null 2>&1; then
  cs setup --yes --jvm adopt:17 || true
fi

# ----------------------------------------------------------------------
# Cleanup
# ----------------------------------------------------------------------

sudo apt autoremove -y
sudo apt clean

echo "Installation complete."
echo "All CLI tools have been installed successfully."
