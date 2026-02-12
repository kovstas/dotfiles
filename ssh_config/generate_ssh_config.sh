#!/usr/bin/env bash

# ----------------------------------------------------------------------
# Generate SSH config Include directive
# Adds an Include line to ~/.ssh/config pointing to the local network
# config snippet from this dotfiles repo.
#
# Safe to run multiple times (idempotent).
# ----------------------------------------------------------------------

set -euo pipefail

SSH_DIR="$HOME/.ssh"
SSH_CONFIG="$SSH_DIR/config"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
INCLUDE_FILE="$SCRIPT_DIR/config_local_network"

if [ ! -f "$INCLUDE_FILE" ]; then
    echo "Error: config_local_network not found at $INCLUDE_FILE"
    exit 1
fi

mkdir -p "$SSH_DIR"
chmod 700 "$SSH_DIR"

if [ ! -f "$SSH_CONFIG" ]; then
    touch "$SSH_CONFIG"
    chmod 600 "$SSH_CONFIG"
fi

INCLUDE_LINE="Include $INCLUDE_FILE"

if grep -qF "$INCLUDE_LINE" "$SSH_CONFIG" 2>/dev/null; then
    echo "SSH config already includes $INCLUDE_FILE"
    exit 0
fi

# Include must appear before any Host/Match blocks to take effect
BACKUP_SUFFIX="_backup_$(date +%Y%m%d_%H%M%S)"

echo "Backing up $SSH_CONFIG to ${SSH_CONFIG}${BACKUP_SUFFIX}"
cp "$SSH_CONFIG" "${SSH_CONFIG}${BACKUP_SUFFIX}"

echo "Adding Include directive to $SSH_CONFIG"
{
    echo "$INCLUDE_LINE"
    echo ""
    cat "$SSH_CONFIG"
} > "${SSH_CONFIG}.tmp"

mv "${SSH_CONFIG}.tmp" "$SSH_CONFIG"
chmod 600 "$SSH_CONFIG"

echo "Done. ~/.ssh/config now includes $INCLUDE_FILE"
echo "----------------------"
head -5 "$SSH_CONFIG"
