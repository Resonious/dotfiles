#!/bin/sh
# Copy credentials from mounted location to dev user's home
if [ -f /tmp/claude-creds/.credentials.json ]; then
    mkdir -p /home/dev/.claude
    cp /tmp/claude-creds/.credentials.json /home/dev/.claude/
    chown -R dev:dev /home/dev/.claude
fi

# Drop to dev user using setpriv (handles TTY correctly)
exec setpriv --reuid=dev --regid=dev --init-groups --reset-env \
    env HOME=/home/dev SHELL=/usr/bin/fish TERM="$TERM" \
    "${@:-fish}"
