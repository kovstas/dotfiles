#!/usr/bin/env bash

# Prompt user for info
read -p "Enter your GitHub username: " GITHUB_USER
read -p "Enter your full name: " GIT_NAME
read -p "Enter your email address: " GIT_EMAIL
read -p "Enter your GPG signing key (leave empty if none): " GIT_SIGNINGKEY

# Target file
CONFIG_FILE="$HOME/.gitconfig.local"

# Write base user config
cat > "$CONFIG_FILE" <<EOF
# Local Git configuration
# Generated on $(date)

[user]
    name = $GIT_NAME
    email = $GIT_EMAIL
EOF

# Add signing key if provided
if [ -n "$GIT_SIGNINGKEY" ]; then
    echo "    signingkey = $GIT_SIGNINGKEY" >> "$CONFIG_FILE"
fi

# OS Detection and 1Password Logic
OS_TYPE=$(uname -s)

if [[ "$OS_TYPE" == "Darwin" ]]; then
    # macOS Logic
    OP_PATH="/Applications/1Password.app/Contents/MacOS/op-ssh-sign"
    if [ -d "/Applications/1Password.app" ]; then
        cat >> "$CONFIG_FILE" <<EOF

[gpg "ssh"]
    program = "$OP_PATH"
EOF
        echo "🍎 macOS 1Password detected."
    fi

elif [[ "$OS_TYPE" == "Linux" ]]; then
    # Linux Logic — use wrapper that switches between local 1Password
    # and ssh-keygen (for forwarded agent over SSH)
    WRAPPER_PATH="$HOME/.local/bin/op-ssh-sign-wrapper.sh"
    if [ -f "$WRAPPER_PATH" ]; then
        cat >> "$CONFIG_FILE" <<EOF

[gpg "ssh"]
    program = "$WRAPPER_PATH"
EOF
        echo "🐧 Linux 1Password signing wrapper configured."
    else
        echo "⚠️  Signing wrapper not found at $WRAPPER_PATH. Run setup_tools.sh first."
    fi
fi

# Add GitHub user
cat >> "$CONFIG_FILE" <<EOF

[github]
    user = $GITHUB_USER
EOF

echo "✅ Created $CONFIG_FILE"
echo "----------------------"
cat "$CONFIG_FILE"
