#!/bin/bash

# This script assumes that Homebrew is already installed and configured.

# Get the directory where this script is located (dotfiles directory)
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
COMMON_DIR="$DOTFILES_DIR/common"
MAC_DIR="$DOTFILES_DIR/mac"
LINUX_DIR="$DOTFILES_DIR/linux"
MAC_DOTCONFIG_DIR="$MAC_DIR/dotconfig"
LINUX_DOTCONFIG_DIR="$LINUX_DIR/dotconfig"
GIT_CONFIG_DIR="$DOTFILES_DIR/git_config"

echo "Setting up dotfiles from: $DOTFILES_DIR"

# Function to create backup and symlink
create_symlink() {
    local source_path="$1"
    local target_path="$2"
    local backup_suffix="_old_$(date +%Y%m%d_%H%M%S)"
    
    # Create target directory if it doesn't exist
    mkdir -p "$(dirname "$target_path")"
    
    # If target exists and is not already a symlink to our source
    if [ -e "$target_path" ] && [ "$(readlink "$target_path" 2>/dev/null)" != "$source_path" ]; then
        echo "Backing up existing $target_path to ${target_path}${backup_suffix}"
        mv "$target_path" "${target_path}${backup_suffix}"
    fi
    
    # Remove existing symlink if it exists but points elsewhere
    if [ -L "$target_path" ] && [ "$(readlink "$target_path")" != "$source_path" ]; then
        echo "Removing old symlink: $target_path"
        rm "$target_path"
    fi
    
    # Create symlink if it doesn't already exist
    if [ ! -L "$target_path" ]; then
        echo "Creating symlink: $target_path -> $source_path"
        ln -s "$source_path" "$target_path"
    else
        echo "Symlink already exists: $target_path"
    fi
}

# Setup Nvim
echo "Setting up Neovim..."
create_symlink "$COMMON_DIR/dotconfig/nvim" "$HOME/.config/nvim"

# Setup Starship
echo "Setting up Starship..."
create_symlink "$COMMON_DIR/dotconfig/starship.toml" "$HOME/.config/starship.toml"

if [[ "$(uname)" == "Darwin" ]]; then
  # SbarLua
  echo "Installing SbarLua..."
  (git clone https://github.com/FelixKratz/SbarLua.git /tmp/SbarLua && cd /tmp/SbarLua/ && make install && rm -rf /tmp/SbarLua/)

  # Setup Aerospace
  echo "Setting up Aerospace..."
  create_symlink "$MAC_DIR/.aerospace.toml" "$HOME/.aerospace.toml"

  echo "Setting up Brew..."
  create_symlink "$MAC_DIR/Brewfile" "$HOME/Brewfile"

  # Setup SketchyBar and install its dependencies
  echo "Setting up SketchyBar..."

  # Create Fonts directory if it doesn't exist
  mkdir -p "$HOME/Library/Fonts"

  if [ ! -f "$HOME/Library/Fonts/sketchybar-app-font.ttf" ]; then
    echo "Downloading sketchybar-app-font..."
    curl -L https://github.com/kvndrsslr/sketchybar-app-font/releases/download/v2.0.25/sketchybar-app-font.ttf -o "$HOME/Library/Fonts/sketchybar-app-font.ttf"
  fi


  # Setup SketchyBar config
  create_symlink "$MAC_DOTCONFIG_DIR/sketchybar" "$HOME/.config/sketchybar"
  echo "Restarting sketchybar service..."
  brew services restart sketchybar

  # Setup borders
  echo "Setting up borders..."
  create_symlink "$MAC_DOTCONFIG_DIR/borders" "$HOME/.config/borders"

  # Setup Ghostty
  echo "Setting up Ghostty..."
  create_symlink "$MAC_DOTCONFIG_DIR/ghostty" "$HOME/.config/ghostty"

fi

if [[ "$(uname)" == "Linux" ]]; then
  echo "Setting up Alacritty"
  create_symlink "$LINUX_DOTCONFIG_DIR/alacritty" "$HOME/.config/alacritty"

  echo "Setting up Autostart"
  create_symlink "$LINUX_DOTCONFIG_DIR/autostart" "$HOME/.config/autostart"

  echo "Setting up Btop"
  create_symlink "$LINUX_DOTCONFIG_DIR/btop" "$HOME/.config/btop"

  echo "Setting up Hyprland"
  create_symlink "$LINUX_DOTCONFIG_DIR/hypr" "$HOME/.config/hypr"

  echo "Setting up background"
  create_symlink "$LINUX_DIR/assets/backgrounds" "$HOME/.local/share/backgrounds"

  echo "Setting up scripts dir"
  create_symlink "$LINUX_DOTCONFIG_DIR/scripts" "$HOME/.config/scripts"

  echo "Setting up vicinae"
  create_symlink "$LINUX_DOTCONFIG_DIR/vicinae" "$HOME/.config/vicinae"

  echo "Setting up ashell"
  create_symlink "$LINUX_DOTCONFIG_DIR/ashell" "$HOME/.config/ashell"

  echo "Setting up hyperpanel"
  create_symlink "$LINUX_DOTCONFIG_DIR/hyprpanel" "$HOME/.config/hyprpanel"

fi

# Setup Zsh
echo "Setting up Zsh..."
create_symlink "$COMMON_DIR/.zshrc" "$HOME/.zshrc"

# Setup .gitconfig
echo "Setting up Git configuration..."
create_symlink "$GIT_CONFIG_DIR/.gitconfig" "$HOME/.gitconfig"
if [[ "$(uname)" == "Darwin" ]]; then
  create_symlink "$GIT_CONFIG_DIR/.gitconfig-1password-mac" "$HOME/.gitconfig-1password-mac"
else
  create_symlink "$GIT_CONFIG_DIR/.gitconfig-1password-linux" "$HOME/.gitconfig-1password-linux"
fi

echo "Setting up Tmux configuration..."
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
create_symlink "$COMMON_DIR/.tmux.conf" "$HOME/.tmux.conf"

echo "Dotfiles setup complete!"
