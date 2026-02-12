#!/bin/bash
# Wrapper script for git commit signing.
# Detects whether 1Password is available locally or we should fall back
# to ssh-keygen (e.g. when using a forwarded SSH agent over a remote session).
#
# This avoids issues with tmux sessions where SSH_CONNECTION can be stale.

OP_SIGN="/opt/1Password/op-ssh-sign"

if [ -x "$OP_SIGN" ] && pgrep -x "1password" > /dev/null 2>&1; then
    exec "$OP_SIGN" "$@"
else
    exec ssh-keygen "$@"
fi
