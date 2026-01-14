#!/bin/sh
# Copy credentials from mounted location to dev user's home
if [ -f /tmp/claude-creds/.credentials.json ]; then
    mkdir -p /home/dev/.claude
    cp /tmp/claude-creds/.credentials.json /home/dev/.claude/
    chown -R dev:dev /home/dev/.claude
fi

# Fix cargo registry permissions (volume may be created as root)
chown -R dev:dev /usr/local/cargo/registry 2>/dev/null || true

# Drop to dev user using setpriv (handles TTY correctly)
export HOME=/home/dev
exec setpriv --reuid=dev --regid=dev --init-groups \
    "${@:-fish}"
