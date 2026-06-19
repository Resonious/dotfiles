#!/bin/sh
# jail2 entrypoint. Runs as root (== host user via rootless podman mapping),
# so no uid remapping / chown gymnastics are needed. Responsibilities:
#   1. Ensure mise baseline tools (from the bind-mounted mise.toml) are present.
#   2. Install Claude Code into the persistent ~/.local/bin volume if missing.
#   3. Install npm-global CLIs (codex, openapi-generator) if missing.
# All of these are no-ops once their persistent volumes are populated, so only
# the very first boot pays the cost.

set -e

export HOME=/root
mkdir -p /root/.local/bin /root/.local/share /root/.npm-global /root/.cargo

# 1. Install/verify mise-managed runtimes defined in the global mise.toml.
#    Quiet no-op when everything is already installed in the volume.
if [ -f /root/.config/mise/config.toml ]; then
    if [ -n "$(mise ls --missing 2>/dev/null)" ]; then
        echo "jail2: installing missing mise tools (one-time)..."
    fi
    mise install --yes || echo "jail2: 'mise install' had errors; continuing."
fi

# 2. Claude Code into the persistent ~/.local/bin volume.
if [ ! -x /root/.local/bin/claude ]; then
    echo "jail2: installing Claude Code..."
    curl -fsSL https://claude.ai/install.sh | bash || true
fi

# 3. npm-global CLIs (need node from mise). Skipped silently if node absent.
if mise which node >/dev/null 2>&1 || command -v npm >/dev/null 2>&1; then
    if ! command -v codex >/dev/null 2>&1; then
        echo "jail2: installing codex..."
        mise exec -- npm install -g @openai/codex || true
    fi
    if ! command -v pi >/dev/null 2>&1; then
        echo "jail2: installing pi (Pi Coding Agent)..."
        mise exec -- npm install -g --ignore-scripts @earendil-works/pi-coding-agent || true
    fi
    if ! command -v openapi-generator-cli >/dev/null 2>&1; then
        echo "jail2: installing openapi-generator-cli..."
        mise exec -- npm install -g @openapitools/openapi-generator-cli || true
    fi
fi

exec "${@:-fish}"
