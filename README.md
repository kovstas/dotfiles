# Dotfiles

Personal dotfiles for macOS and Linux development environments.

## Quick Start

```bash
# Clone the repository
git clone https://github.com/kovstas/dotfiles.git ~/projects/dotfiles
cd ~/projects/dotfiles

# Run the setup script
./setup_tools.sh

# Generate local git config (interactive)
./git_config/generate_gitconfig_local.sh
```

## What's Included

### Cross-Platform (common/)

| Tool | Description |
|------|-------------|
| **Neovim** | Kickstart-based config with LSP, Telescope, and custom plugins |
| **Zsh** | Oh-my-zsh with autosuggestions, syntax highlighting |
| **tmux** | Catppuccin theme, vim-tmux-navigator, session management |
| **Starship** | Cross-shell prompt |
| **Git** | Global config with 1Password SSH signing |

### macOS (mac/)

| Tool | Description |
|------|-------------|
| **Aerospace** | Tiling window manager with vim-style navigation |
| **SketchyBar** | Custom status bar with app icons |
| **Ghostty** | GPU-accelerated terminal |
| **Homebrew** | Brewfile with all packages |

### Linux (linux/)

| Tool | Description |
|------|-------------|
| **Hyprland** | Wayland compositor with animations |
| **Alacritty** | GPU-accelerated terminal |
| **btop** | System monitor |
| **Various** | ashell, vicinae, hyprpanel configs |

## Directory Structure

```
dotfiles/
├── common/                 # Cross-platform configurations
│   ├── .zshrc
│   ├── .tmux.conf
│   ├── .editorconfig
│   └── dotconfig/
│       ├── nvim/           # Neovim config
│       └── starship.toml
├── git_config/             # Git configuration
│   ├── .gitconfig
│   ├── .gitignore_global
│   └── generate_gitconfig_local.sh
├── langs/                  # Language-specific setup
│   └── python/
│       ├── bootstrap.sh
│       └── requirements-global.txt
├── linux/                  # Linux-specific configs
│   ├── deb_install_dev_tools.sh
│   └── dotconfig/
├── mac/                    # macOS-specific configs
│   ├── .aerospace.toml
│   ├── .macos
│   ├── Brewfile
│   └── dotconfig/
├── setup_tools.sh          # Main installation script
└── README.md
```

## Setup Scripts

### Main Setup (`setup_tools.sh`)

Creates symlinks from this repository to their expected locations. Handles:
- Automatic backup of existing files (timestamped)
- OS detection (macOS vs Linux)
- Idempotent execution

### Python Setup (`langs/python/bootstrap.sh`)

```bash
./langs/python/bootstrap.sh
```

Sets up:
- pyenv with Python 3.14.0
- Global virtualenv with dev tools (black, ruff, mypy, pytest, etc.)

### Linux Dev Tools (`linux/deb_install_dev_tools.sh`)

```bash
./linux/deb_install_dev_tools.sh
```

Installs CLI tools on Debian/Ubuntu:
- Core: neovim, tmux, zsh, starship, lazygit
- Cloud: terraform, kubectl, helm, k9s, awscli
- Languages: pyenv, nvm, coursier (Scala)

## Key Features

### AI Coding Integration

Two AI assistants with unified keybindings:

| Action | Claude Code | OpenCode |
|--------|-------------|----------|
| Toggle | `<leader>ac` | `<leader>oc` |
| Focus | `<leader>af` | `<leader>of` |
| Send selection | `<leader>as` | `<leader>oS` |
| Quick chat | - | `<leader>o/` |

tmux popups (prefix `C-s`):
- `C-c` - Claude Code (90% popup)
- `C-o` - OpenCode (90% popup)
- `o` - OpenCode (45% side pane)

### Vim-Style Navigation

Consistent `hjkl` navigation across:
- Neovim (native)
- tmux panes (vim-tmux-navigator)
- Aerospace windows (macOS)
- Hyprland windows (Linux)

### Theme

Catppuccin Mocha everywhere:
- tmux status bar
- Terminal colors
- Neovim (via plugins)

## Neovim Plugins

Key plugins included:
- **LSP**: Native LSP with mason for server management
- **Completion**: nvim-cmp with snippets
- **Navigation**: Telescope, oil.nvim, neo-tree
- **Git**: neogit, gitsigns
- **AI**: claudecode.nvim, opencode.nvim

## Requirements

### macOS
- Homebrew
- Xcode Command Line Tools

### Linux
- Debian/Ubuntu-based distro
- sudo access for package installation

## Customization

### Local Git Config

The setup script creates symlinks to shared git config. Personal settings go in `~/.gitconfig.local`:

```bash
./git_config/generate_gitconfig_local.sh
```

### Neovim Plugins

Add custom plugins in `common/dotconfig/nvim/lua/custom/plugins/`. Each file should return a lazy.nvim spec.

## License

MIT
