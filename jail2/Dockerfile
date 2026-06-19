# jail2 — minimal base image. Languages/runtimes are managed by mise at
# runtime (see mise.toml), NOT baked in here. The container runs as root so
# that rootless podman's default uid mapping (container root -> host user)
# gives correct file ownership on bind mounts with no --userns=keep-id cost.

FROM ubuntu:26.04

ENV DEBIAN_FRONTEND=noninteractive

# System packages only. Everything language-shaped comes from mise.
# The lib*-dev packages serve double duty: the runtime shared libs they pull in
# (libyaml, libffi, libssl, zlib, readline, gdbm, ncurses, gmp) are what mise's
# *precompiled* Ruby dynamically links against at runtime, and the headers let
# you build native gem extensions (nokogiri, pg, ...). build-essential also
# covers source-compiled tools like erlang (kerl).
RUN apt-get update && apt-get install -y --no-install-recommends \
        ca-certificates \
        curl \
        wget \
        unzip \
        xz-utils \
        gnupg \
        git \
        fish \
        fzf \
        ripgrep \
        sudo \
        locales \
        # browser/runtime UI libraries \
        libglib2.0-0 \
        libnspr4 \
        libnss3 \
        libatk-bridge2.0-0 \
        libatk1.0-0 \
        libcups2 \
        libdrm2 \
        libdbus-1-3 \
        libxkbcommon0 \
        libxcomposite1 \
        libxdamage1 \
        libxfixes3 \
        libxrandr2 \
        libgbm1 \
        libpango-1.0-0 \
        libcairo2 \
        libasound2t64 \
        libx11-6 \
        libxcb1 \
        libxext6 \
        libxshmfence1 \
        # build toolchain for mise-compiled tools \
        build-essential \
        pkg-config \
        autoconf \
        bison \
        libssl-dev \
        zlib1g-dev \
        libyaml-dev \
        libgdbm-dev \
        libreadline-dev \
        libncurses-dev \
        libffi-dev \
        libgmp-dev \
    && rm -rf /var/lib/apt/lists/*

# Sensible UTF-8 locale
RUN locale-gen en_US.UTF-8
ENV LANG=en_US.UTF-8 LC_ALL=en_US.UTF-8

# Install mise into /usr/local/bin (outside any mounted volume so it is always
# present regardless of which dirs get volume-mounted at runtime).
RUN curl -fsSL https://mise.run | MISE_INSTALL_PATH=/usr/local/bin/mise sh

# Environment for tools that live in mounted volumes at runtime.
#   - mise data (installed runtimes + shims)
#   - npm global prefix (codex, openapi-generator-cli, ...)
#   - cargo
#   - claude binary in ~/.local/bin
ENV MISE_DATA_DIR=/root/.local/share/mise \
    NPM_CONFIG_PREFIX=/root/.npm-global \
    CARGO_HOME=/root/.cargo \
    RUSTUP_HOME=/root/.rustup \
    CARGO_NET_GIT_FETCH_WITH_CLI=true \
    RUSTUP_INIT_SKIP_PATH_CHECK=yes \
    SHELL=/usr/bin/fish \
    COLORTERM=truecolor
ENV PATH=/root/.bun/bin:/root/.local/share/mise/shims:/root/.local/bin:/root/.npm-global/bin:/root/.cargo/bin:${PATH}

# Rust via rustup (NOT mise). mise's rust support just wraps rustup, and the
# extra indirection caused reinstall/corruption across fresh containers. Native
# rustup into the persistent RUSTUP_HOME/CARGO_HOME volumes is reliable. The
# baked toolchain seeds those volumes on first run (podman copy-up).
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --default-toolchain stable \
    && rustup component add rust-analyzer

# git: trust bind-mounted project dirs regardless of ownership
RUN git config --system --add safe.directory '*'

# Skip Claude Code onboarding wizard
RUN echo '{"hasCompletedOnboarding": true, "theme": "dark"}' > /root/.claude.json

# Helix config (helix itself comes from mise)
RUN mkdir -p /root/.config/helix && \
    printf '%s\n' 'theme = "gruvbox_dark_hard"' > /root/.config/helix/config.toml

# Fish config (orange/red jail prompt + color scheme). Shipped as a real file.
RUN mkdir -p /root/.config/fish
COPY config.fish /root/.config/fish/config.fish

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

WORKDIR /root
ENTRYPOINT ["/entrypoint.sh"]
CMD ["fish"]

