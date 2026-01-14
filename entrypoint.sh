#!/bin/sh
# Copy credentials into the claude home volume (always update in case token refreshed)
if [ -f /tmp/claude-creds.json ]; then
    cp /tmp/claude-creds.json /home/dev/.claude/.credentials.json
fi

# Fix claude home permissions (volume may be created as root)
chown -R dev:dev /home/dev/.claude 2>/dev/null || true

# Fix cargo registry permissions (volume may be created as root)
chown -R dev:dev /usr/local/cargo/registry 2>/dev/null || true

# Fix npm user global permissions
chown -R dev:dev /home/dev/.npm-global 2>/dev/null || true

# Drop to dev user using setpriv (handles TTY correctly)
export HOME=/home/dev
exec setpriv --reuid=dev --regid=dev --init-groups \
    "${@:-fish}"
