#!/bin/bash
# Wrapper script for git commit signing.
# Detects whether 1Password is available locally or we should fall back
# to ssh-keygen (e.g. when using a forwarded SSH agent over a remote session).
#
# Works on both macOS and Linux:
#   macOS: checks for 1Password.app
#   Linux: checks for 1password process
#
# This avoids issues with tmux sessions where SSH_CONNECTION can be stale.

case "$(uname -s)" in
    Darwin)
        OP_SIGN="/Applications/1Password.app/Contents/MacOS/op-ssh-sign"
        op_running() { pgrep -xq "1Password" 2>/dev/null; }
        ;;
    Linux)
        OP_SIGN="/opt/1Password/op-ssh-sign"
        op_running() { pgrep -x "1password" >/dev/null 2>&1; }
        ;;
    *)
        exec ssh-keygen "$@"
        ;;
esac

if [ -x "$OP_SIGN" ] && op_running; then
    exec "$OP_SIGN" "$@"
else
    exec ssh-keygen "$@"
fi
