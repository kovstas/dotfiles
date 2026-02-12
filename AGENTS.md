# AGENTS.md - AI Coding Agent Guidelines

This document provides context for AI coding agents (OpenCode, Claude Code, etc.) working in this dotfiles repository.

## Repository Overview

Personal dotfiles for macOS and Linux development environments. Configuration files are symlinked from this repo to their expected locations.

### Directory Structure

```
dotfiles/
├── common/                 # Cross-platform configs
│   ├── .editorconfig       # Editor config (Lua indent rules)
│   ├── .emacs.d/           # Emacs configuration
│   ├── .tmux.conf          # tmux config (Catppuccin, vim-tmux-navigator)
│   ├── .zshrc              # Zsh config (oh-my-zsh, pyenv, conda, SDKMAN)
│   └── dotconfig/
│       ├── nvim/           # Neovim config (kickstart-based, lazy.nvim)
│       └── starship.toml   # Starship prompt config
├── git_config/             # Git configuration
│   ├── .gitconfig          # Global git config (SSH signing, nvim editor)
│   ├── .gitignore_global   # Global gitignore
│   ├── generate_gitconfig_local.sh  # Interactive local config generator
│   └── op-ssh-sign-wrapper.sh       # 1Password SSH signing wrapper (Linux)
├── langs/                  # Language-specific setup
│   └── python/
│       ├── bootstrap.sh              # pyenv + global-dev virtualenv setup
│       └── requirements-global.txt   # Global Python dev tools
├── linux/                  # Linux-specific configs
│   ├── assets/             # Backgrounds, etc.
│   ├── deb_install_dev_tools.sh  # Debian/Ubuntu dev tools installer
│   └── dotconfig/          # alacritty, ashell, autostart, btop, hypr,
│                           # hyprpanel, scripts, vicinae
├── mac/                    # macOS-specific configs
│   ├── .aerospace.toml     # Aerospace tiling WM config
│   ├── .macos              # macOS defaults
│   ├── Brewfile            # Homebrew packages, casks, MAS apps
│   └── dotconfig/          # borders, ghostty, sketchybar
├── setup_tools.sh          # Main installation script (symlinks + deps)
└── AGENTS.md
```

## Setup Commands

```bash
# Main dotfiles installation (creates symlinks, installs deps)
./setup_tools.sh

# Generate local git config (interactive)
./git_config/generate_gitconfig_local.sh

# Python environment setup (pyenv 3.14.0 + global-dev virtualenv)
./langs/python/bootstrap.sh

# Linux dev tools installation (Debian/Ubuntu, requires sudo)
./linux/deb_install_dev_tools.sh
```

## Shell Script Guidelines

### Shebang

- Use `#!/usr/bin/env bash` for portable scripts
- Use `#!/bin/bash` for scripts that require bash-specific features
- Use `#!/bin/sh` for POSIX-compatible scripts

### Error Handling

```bash
# For critical scripts, use strict mode:
set -euo pipefail

# Check command existence before use:
if ! command -v some_tool >/dev/null 2>&1; then
  echo "Error: some_tool not found"
  exit 1
fi
```

### Variable Naming

- `SCREAMING_SNAKE_CASE` for constants and environment variables
- `snake_case` for local variables
- Always quote variables: `"$variable"`

### Function Style

```bash
# Function definition
create_symlink() {
    local source_path="$1"
    local target_path="$2"
    # implementation
}
```

### Section Headers

```bash
# ----------------------------------------------------------------------
# Section Name
# ----------------------------------------------------------------------
```

## Lua (Neovim) Guidelines

### StyLua Configuration

The project uses StyLua with these settings (see `common/dotconfig/nvim/.stylua.toml`):

- Column width: 160
- Indent: 2 spaces
- Quote style: Single quotes preferred (`AutoPreferSingle`)
- Call parentheses: None (idiomatic Lua)

### Style Examples

```lua
-- Single quotes, no parentheses for requires
local telescope = require 'telescope.builtin'

-- 2-space indentation
return {
  'plugin/name',
  opts = {
    setting = true,
  },
}
```

### Neovim Architecture

Kickstart-based config using lazy.nvim for plugin management.

```
common/dotconfig/nvim/
├── init.lua                          # Main config (options, keymaps, core plugins)
├── .stylua.toml                      # StyLua formatter config
├── lua/
│   ├── kickstart/plugins/            # Kickstart-bundled plugins
│   │   ├── autopairs.lua
│   │   ├── debug.lua
│   │   ├── gitsigns.lua
│   │   ├── indent_line.lua
│   │   ├── lint.lua
│   │   └── neo-tree.lua
│   └── custom/plugins/               # User plugins (each returns a lazy.nvim spec)
│       ├── claude.lua                # Claude Code AI assistant (coder/claudecode.nvim)
│       ├── cmp.lua                   # Completion overrides
│       ├── comment.lua               # Code commenting
│       ├── copilot.lua               # GitHub Copilot
│       ├── cyrillic.lua              # Cyrillic keyboard support
│       ├── esp32.lua                 # ESP32 development
│       ├── init.lua                  # Plugin index
│       ├── metals.lua                # Scala LSP (nvim-metals)
│       ├── neogit.lua                # Git interface
│       ├── oil.lua                   # File explorer
│       ├── opencode.lua              # OpenCode AI assistant (sudo-tee/opencode.nvim)
│       ├── slime.lua                 # REPL integration
│       ├── snacks.lua                # Snacks.nvim utilities
│       ├── typescript-tools.lua      # TypeScript LSP tools
│       ├── venv-selector.lua         # Python venv selection
│       └── vim-tmux-navigator.lua    # tmux/nvim navigation
└── lazy-lock.json                    # Plugin version lock file
```

### Key Neovim Details

- **Completion**: blink.cmp (saghen/blink.cmp) with LuaSnip snippets
- **Colorscheme**: tokyonight-night (`folke/tokyonight.nvim`)
- **LSP servers**: clangd, basedpyright, rust_analyzer, terraformls, lua_ls (via mason)
- **Formatters** (conform.nvim): stylua (Lua), isort+black+ruff (Python), scalafmt (Scala), prettierd/prettier (JS/TS/JSON)
- **Leader key**: `<Space>`

## Python Guidelines

### Tools

- **Formatter**: black (24.3.0), isort (5.12.0)
- **Linter**: ruff (0.12.7), flake8 (6.1.0)
- **Type checker**: mypy (1.10.0)
- **Testing**: pytest (8.4.1)
- **Debug**: debugpy (1.8.15)
- **Package manager**: uv (0.8.6)
- **REPL**: ipython (9.6.0)

### Environment

Python environments are managed via pyenv. Global tools are installed in a `global-dev` virtualenv (Python 3.14.0). Conda/Miniforge is also available for scientific/ML workloads.

## Linting and Formatting

| Language        | Tools                                    |
|-----------------|------------------------------------------|
| Lua             | stylua                                   |
| Python          | black, isort, ruff, flake8, mypy         |
| Scala           | scalafmt                                 |
| JS/TS/JSON      | prettierd, prettier                      |
| Shell           | shellcheck (recommended)                 |
| Terraform/HCL   | terraform fmt, tflint                    |

## AI Coding Integration

This repository uses two AI coding assistants with unified keybinding patterns:

### Claude Code (`<leader>a*`) -- `coder/claudecode.nvim`

```
<leader>ac  Toggle Claude
<leader>af  Focus Claude
<leader>ar  Resume session
<leader>aC  Continue
<leader>ab  Add current buffer
<leader>as  Send selection (visual) / Add file (tree)
<leader>aa  Accept diff
<leader>ad  Deny diff
```

### OpenCode (`<leader>o*`) -- `sudo-tee/opencode.nvim`

```
<leader>oc   Toggle OpenCode
<leader>of   Focus OpenCode
<leader>oi   Open input
<leader>oI   New session
<leader>oo   Open output
<leader>oq   Close
<leader>os   Select session
<leader>oS   Send selection (visual)
<leader>op   Configure provider/model
<leader>od   Open diff view
<leader>o]   Next diff
<leader>o[   Previous diff
<leader>ox   Close diff
<leader>ora  Revert all diffs from last prompt
<leader>ort  Revert this diff from last prompt
<leader>o/   Quick chat (normal/visual)
```

### tmux AI & Tool Popups (prefix: C-s)

```
C-s C-c    Claude Code popup (90%)
C-s C-o    OpenCode popup (90%)
C-s o      OpenCode side pane (45%)
C-s C-y    LazyGit popup (80%)
C-s C-p    IPython popup
```

## Important Patterns

### OS Detection

```bash
if [[ "$(uname)" == "Darwin" ]]; then
  # macOS
elif [[ "$(uname)" == "Linux" ]]; then
  # Linux
fi
```

### Symlink Creation

The `create_symlink` function in `setup_tools.sh`:
1. Creates parent directories if needed
2. Backs up existing files with timestamp suffix
3. Creates idempotent symlinks

### Idempotent Installation

```bash
# Check before installing
if [ ! -d "$HOME/.some_tool" ]; then
  echo "Installing some_tool..."
  # installation commands
fi
```

### Local Overrides

- `~/.zshrc.local` -- sourced at end of `.zshrc` for machine-specific shell config
- `~/.gitconfig.local` -- included in `.gitconfig` for personal name/email/signing

## Configuration Locations

| Tool           | Config Location                                |
|----------------|------------------------------------------------|
| Neovim         | `~/.config/nvim` -> `common/dotconfig/nvim`    |
| Zsh            | `~/.zshrc` -> `common/.zshrc`                  |
| tmux           | `~/.tmux.conf` -> `common/.tmux.conf`          |
| Starship       | `~/.config/starship.toml` -> `common/dotconfig/starship.toml` |
| Git            | `~/.gitconfig` -> `git_config/.gitconfig`      |
| Git (ignore)   | `~/.gitignore_global` -> `git_config/.gitignore_global` |
| **macOS only** | |
| Aerospace      | `~/.aerospace.toml` -> `mac/.aerospace.toml`   |
| Brewfile       | `~/Brewfile` -> `mac/Brewfile`                 |
| SketchyBar     | `~/.config/sketchybar` -> `mac/dotconfig/sketchybar` |
| Borders        | `~/.config/borders` -> `mac/dotconfig/borders` |
| Ghostty        | `~/.config/ghostty` -> `mac/dotconfig/ghostty` |
| **Linux only** | |
| Alacritty      | `~/.config/alacritty` -> `linux/dotconfig/alacritty` |
| Hyprland       | `~/.config/hypr` -> `linux/dotconfig/hypr`     |
| btop           | `~/.config/btop` -> `linux/dotconfig/btop`     |
| ashell         | `~/.config/ashell` -> `linux/dotconfig/ashell`  |
| vicinae        | `~/.config/vicinae` -> `linux/dotconfig/vicinae` |
| HyprPanel      | `~/.config/hyprpanel` -> `linux/dotconfig/hyprpanel` |
| Autostart      | `~/.config/autostart` -> `linux/dotconfig/autostart` |
| Scripts        | `~/.config/scripts` -> `linux/dotconfig/scripts` |
| 1P SSH wrapper | `~/.local/bin/op-ssh-sign-wrapper.sh` -> `git_config/op-ssh-sign-wrapper.sh` |

## Zsh Environment

Oh-my-zsh with these notable plugins: `1password`, `aws`, `docker`, `docker-compose`, `git`, `helm`, `k9s`, `nvm`, `pip`, `python`, `rust`, `sbt`, `sdk`, `starship`, `terraform`, `thefuck`, `tmux`.

Additional environment integrations:
- **pyenv** -- Python version management
- **nvm** -- Node.js version management
- **SDKMAN** -- JVM toolchain management
- **Conda/Miniforge/Mamba** -- Scientific Python environments
- **ESP-IDF** -- ESP32 development (via `get_idf` / `get_esp` aliases)
- **Coursier** -- Scala toolchain (Linux PATH setup)

## Do NOT

- Commit secrets or credentials
- Modify files outside the dotfiles directory structure
- Create backup files (the setup script handles backups)
- Use `cd` in scripts when `pushd/popd` or subshells work better
- Edit `~/.zshrc.local` or `~/.gitconfig.local` (machine-specific, not tracked)
