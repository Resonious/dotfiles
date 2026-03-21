#!/bin/sh
mkdir -p /home/dev/.local/bin /home/dev/.local/share/claude

if [ "$(id -u)" = "0" ]; then
    # Running as root (no --userns=keep-id) — fix volume permissions and drop to dev
    chown -R dev:dev /home/dev/.local/bin /home/dev/.local/share/claude
    chown -R dev:dev /home/dev/.claude 2>/dev/null || true
    chown -R dev:dev /usr/local/cargo/registry 2>/dev/null || true
    chown -R dev:dev /home/dev/.npm-global 2>/dev/null || true
fi

# Install Claude Code if not present (into persistent volume)
if [ ! -x /home/dev/.local/bin/claude ]; then
    echo "Installing Claude Code..."
    if [ "$(id -u)" = "0" ]; then
        su dev -c 'curl -fsSL https://claude.ai/install.sh | bash'
    else
        curl -fsSL https://claude.ai/install.sh | bash
    fi
fi

# Copy credentials into the claude home volume (always update in case token refreshed)
if [ -f /tmp/claude-creds.json ]; then
    cp /tmp/claude-creds.json /home/dev/.claude/.credentials.json
fi

export HOME=/home/dev
if [ "$(id -u)" = "0" ]; then
    exec setpriv --reuid=dev --regid=dev --init-groups \
        "${@:-fish}"
else
    exec "${@:-fish}"
fi
