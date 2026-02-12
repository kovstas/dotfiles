# AGENTS.md - AI Coding Agent Guidelines

This document provides context for AI coding agents (OpenCode, Claude Code, etc.) working in this dotfiles repository.

## Repository Overview

Personal dotfiles for macOS and Linux development environments. Configuration files are symlinked from this repo to their expected locations.

### Directory Structure

```
dotfiles/
├── common/           # Cross-platform configs (zsh, tmux, nvim, starship)
├── git_config/       # Git configuration and helpers
├── langs/            # Language-specific setup (Python, etc.)
├── linux/            # Linux-specific configs (Hyprland, Alacritty)
├── mac/              # macOS-specific configs (Aerospace, Ghostty, SketchyBar)
└── setup_tools.sh    # Main installation script
```

## Setup Commands

```bash
# Main dotfiles installation (creates symlinks)
./setup_tools.sh

# Generate local git config (interactive)
./git_config/generate_gitconfig_local.sh

# Python environment setup (pyenv + global tools)
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
- Quote style: Single quotes preferred
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

### Plugin File Structure

Neovim plugins live in `common/dotconfig/nvim/lua/custom/plugins/`. Each plugin gets its own file returning a lazy.nvim spec.

## Python Guidelines

### Tools

- **Formatter**: black, isort
- **Linter**: ruff, flake8
- **Type checker**: mypy
- **Testing**: pytest

### Environment

Python environments are managed via pyenv. Global tools are installed in a `global-dev` virtualenv.

## Linting and Formatting

| Language   | Tools                        |
|------------|------------------------------|
| Lua        | stylua                       |
| Python     | black, isort, ruff, mypy     |
| Shell      | shellcheck (recommended)     |
| Terraform  | terraform fmt, tflint        |

## AI Coding Integration

This repository uses two AI coding assistants with unified keybinding patterns:

### Claude Code (`<leader>a*`)

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

### OpenCode (`<leader>o*`)

```
<leader>oc  Toggle OpenCode
<leader>of  Focus OpenCode
<leader>oi  Open input
<leader>oI  New session
<leader>oo  Open output
<leader>oq  Close
<leader>os  Select session
<leader>oS  Send selection (visual)
<leader>op  Configure provider/model
<leader>od  Open diff view
<leader>o/  Quick chat (normal/visual)
```

### tmux AI Popups (prefix: C-s)

```
C-s C-c    Claude Code popup (90%)
C-s C-o    OpenCode popup (90%)
C-s o      OpenCode side pane (45%)
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

## Configuration Locations

| Tool       | Config Location                          |
|------------|------------------------------------------|
| Neovim     | `~/.config/nvim` -> `common/dotconfig/nvim` |
| Zsh        | `~/.zshrc` -> `common/.zshrc`            |
| tmux       | `~/.tmux.conf` -> `common/.tmux.conf`    |
| Starship   | `~/.config/starship.toml`                |
| Git        | `~/.gitconfig` -> `git_config/.gitconfig`|

## Do NOT

- Commit secrets or credentials
- Modify files outside the dotfiles directory structure
- Create backup files (the setup script handles backups)
- Use `cd` in scripts when `pushd/popd` or subshells work better
