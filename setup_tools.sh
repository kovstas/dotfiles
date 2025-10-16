#!/bin/bash

# This script assumes that Homebrew is already installed and configured.

# Get the directory where this script is located (dotfiles directory)
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

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

# SbarLua
echo "Installing SbarLua..."
(git clone https://github.com/FelixKratz/SbarLua.git /tmp/SbarLua && cd /tmp/SbarLua/ && make install && rm -rf /tmp/SbarLua/)

# Setup Nvim
echo "Setting up Neovim..."
create_symlink "$DOTFILES_DIR/.config/nvim" "$HOME/.config/nvim"

echo "Setting up Neovim..."
create_symlink "$DOTFILES_DIR/Brewfile" "$HOME/Brewfile"

# Setup Starship
echo "Setting up Starship..."
create_symlink "$DOTFILES_DIR/.config/starship.toml" "$HOME/.config/starship.toml"

if [[ "$(uname)" == "Darwin" ]]; then
  # Setup Aerospace
  echo "Setting up Aerospace..."
  create_symlink "$DOTFILES_DIR/.aerospace.toml" "$HOME/.aerospace.toml"

  # Setup SketchyBar and install its dependencies
echo "Setting up SketchyBar..."

# Create Fonts directory if it doesn't exist
mkdir -p "$HOME/Library/Fonts"

if [ ! -f "$HOME/Library/Fonts/sketchybar-app-font.ttf" ]; then
    echo "Downloading sketchybar-app-font..."
    curl -L https://github.com/kvndrsslr/sketchybar-app-font/releases/download/v2.0.25/sketchybar-app-font.ttf -o "$HOME/Library/Fonts/sketchybar-app-font.ttf"
fi


  # Setup SketchyBar config
	create_symlink "$DOTFILES_DIR/.config/sketchybar" "$HOME/.config/sketchybar"
	echo "Restarting sketchybar service..."
	brew services restart sketchybar

	# Setup borders
	echo "Setting up borders..."
	create_symlink "$DOTFILES_DIR/.config/borders" "$HOME/.config/borders"

	# Setup Ghostty
	echo "Setting up Ghostty..."
	create_symlink "$DOTFILES_DIR/.config/ghostty" "$HOME/.config/ghostty"

fi

# Setup Zsh
echo "Setting up Zsh..."
create_symlink "$DOTFILES_DIR/.zshrc" "$HOME/.zshrc"

# Setup .gitconfig
echo "Setting up Git configuration..."
create_symlink "$DOTFILES_DIR/.gitconfig" "$HOME/.gitconfig"
if [[ "$(uname)" == "Darwin" ]]; then
  create_symlink "$DOTFILES_DIR/.gitconfig-1password" "$HOME/.gitconfig-1password"
fi

echo "Setting up Tmux configuration..."
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
create_symlink "$DOTFILES_DIR/.tmux.conf" "$HOME/.tmux.conf"

echo "Dotfiles setup complete!"
