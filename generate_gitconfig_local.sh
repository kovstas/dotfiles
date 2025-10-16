#!/usr/bin/env bash

# Prompt user for info
read -p "Enter your GitHub username: " GITHUB_USER
read -p "Enter your full name: " GIT_NAME
read -p "Enter your email address: " GIT_EMAIL
read -p "Enter your GPG signing key (leave empty if none): " GIT_SIGNINGKEY

# Target file
CONFIG_FILE="$HOME/.gitconfig.local"

# Write config
cat > "$CONFIG_FILE" <<EOF
# Local Git configuration
# Generated on $(date)

[user]
    name = $GIT_NAME
    email = $GIT_EMAIL
EOF

# Add signing key if provided
if [ -n "$GIT_SIGNINGKEY" ]; then
cat >> "$CONFIG_FILE" <<EOF
    signingkey = $GIT_SIGNINGKEY
EOF
fi

cat >> "$CONFIG_FILE" <<EOF

[github]
    user = $GITHUB_USER
EOF

echo "✅ Created $CONFIG_FILE"
cat "$CONFIG_FILE"
