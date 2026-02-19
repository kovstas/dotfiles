#!/bin/bash
# Wrapper script for git commit signing.
# Detects whether 1Password is available locally or we should fall back
# to ssh-keygen (e.g. when using a forwarded SSH agent over a remote session).
#
# Works on both macOS and Linux:
#   macOS: checks for 1Password.app
#   Linux: checks for 1password process
#
# When connected via SSH (remote session), always use ssh-keygen so that
# the forwarded agent from the local machine handles signing — even if
# 1Password happens to be running on the remote host.

# If we're in a remote SSH session, use the forwarded agent via ssh-keygen.
# SSH_TTY is set by sshd for interactive sessions (survives tmux/screen).
if [ -n "$SSH_TTY" ]; then
    exec ssh-keygen "$@"
fi

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
