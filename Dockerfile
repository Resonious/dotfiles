FROM debian:bookworm-slim

# Avoid prompts during package installation
ENV DEBIAN_FRONTEND=noninteractive

# Create non-root user early
RUN useradd -m -s /usr/bin/fish -u 1000 dev

# Install base dependencies
RUN apt-get update && apt-get install -y \
    curl \
    wget \
    unzip \
    ca-certificates \
    gnupg \
    build-essential \
    pkg-config \
    libssl-dev \
    git \
    fish \
    fzf \
    ripgrep \
    openjdk-17-jre-headless \
    bison \
    zlib1g-dev \
    libyaml-dev \
    libgdbm-dev \
    libreadline-dev \
    libncurses-dev \
    libffi-dev \
    libgmp-dev \
    && rm -rf /var/lib/apt/lists/*

# Install GitHub CLI
RUN curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg -o /usr/share/keyrings/githubcli-archive-keyring.gpg \
    && echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" \
    > /etc/apt/sources.list.d/github-cli.list \
    && apt-get update && apt-get install -y gh \
    && rm -rf /var/lib/apt/lists/*

# Install Ruby via ruby-install for newer version
RUN curl -fsSL https://github.com/postmodern/ruby-install/releases/download/v0.10.2/ruby-install-0.10.2.tar.gz | tar xz \
    && cd ruby-install-0.10.2 \
    && make install \
    && cd .. && rm -rf ruby-install-0.10.2 \
    && ruby-install --system ruby 4.0.2 \
    && gem install bundler

# Install AWS CLI v2
RUN curl -fsSL "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o awscliv2.zip \
    && unzip -q awscliv2.zip \
    && ./aws/install \
    && rm -rf aws awscliv2.zip

# Install Erlang/OTP and rebar3
RUN apt-get update && apt-get install -y erlang rebar3 \
    && rm -rf /var/lib/apt/lists/*

# Install Gleam
RUN curl -LO https://github.com/gleam-lang/gleam/releases/download/v1.14.0/gleam-v1.14.0-x86_64-unknown-linux-musl.tar.gz \
    && tar xzf gleam-v1.14.0-x86_64-unknown-linux-musl.tar.gz \
    && mv gleam /usr/local/bin/ \
    && rm gleam-v1.14.0-x86_64-unknown-linux-musl.tar.gz

# Install Neovim (latest stable from GitHub releases)
RUN curl -LO https://github.com/neovim/neovim/releases/download/v0.11.1/nvim-linux-x86_64.tar.gz \
    && tar xzf nvim-linux-x86_64.tar.gz \
    && mv nvim-linux-x86_64 /opt/nvim \
    && ln -s /opt/nvim/bin/nvim /usr/local/bin/nvim \
    && rm nvim-linux-x86_64.tar.gz

# Install Rust and Cargo via rustup
ENV RUSTUP_HOME=/usr/local/rustup \
    CARGO_HOME=/usr/local/cargo \
    PATH=/usr/local/cargo/bin:$PATH

RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --default-toolchain stable \
    && rustup component add rust-analyzer

# Install Bun
ENV BUN_INSTALL=/usr/local/bun
RUN curl -fsSL https://bun.sh/install | bash \
    && ln -s /usr/local/bun/bin/bun /usr/local/bin/bun \
    && ln -s /usr/local/bun/bin/bunx /usr/local/bin/bunx

# Install Node.js (required for openapi-generator-cli)
RUN curl -fsSL https://deb.nodesource.com/setup_22.x | bash - \
    && apt-get install -y nodejs \
    && rm -rf /var/lib/apt/lists/*

# Install openapi-generator-cli (requires Java which we installed above)
# Pre-download the JAR and fix permissions for non-root usage
RUN npm install -g @openapitools/openapi-generator-cli \
    && openapi-generator-cli version \
    && chmod -R 777 /usr/lib/node_modules/@openapitools/openapi-generator-cli/versions

# npm packages we want
RUN npm install -g typescript typescript-language-server

# Set up user npm global directory for persistent MCP servers etc.
RUN mkdir -p /home/dev/.npm-global && \
    chown dev:dev /home/dev/.npm-global

# Set up .local directory for Claude Code (will be mounted as volume)
RUN mkdir -p /home/dev/.local/bin /home/dev/.local/share/claude && \
    chown -R dev:dev /home/dev/.local

# Set up user gem directory for Ruby
RUN mkdir -p /home/dev/.gem && \
    chown dev:dev /home/dev/.gem
ENV GEM_HOME=/home/dev/.gem \
    GEM_PATH=/home/dev/.gem:/usr/local/lib/ruby/gems/3.3.0
ENV NPM_CONFIG_PREFIX=/home/dev/.npm-global \
    PATH=/home/dev/.gem/bin:/home/dev/.npm-global/bin:/usr/local/cargo/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

# Install Nix (single-user, no daemon — installs to /nix owned by dev)
RUN mkdir -m 0755 /nix && chown dev:dev /nix
USER dev
RUN curl -L https://nixos.org/nix/install | sh -s -- --no-daemon \
    && mkdir -p /home/dev/.config/nix \
    && echo 'experimental-features = nix-command flakes' > /home/dev/.config/nix/nix.conf
USER root
ENV PATH="/home/dev/.nix-profile/bin:${PATH}"

# Install Helix editor
RUN curl -LO https://github.com/helix-editor/helix/releases/download/25.07.1/helix-25.07.1-x86_64-linux.tar.xz \
    && tar xf helix-25.07.1-x86_64-linux.tar.xz \
    && mv helix-25.07.1-x86_64-linux /opt/helix \
    && ln -s /opt/helix/hx /usr/local/bin/hx \
    && rm helix-25.07.1-x86_64-linux.tar.xz
ENV HELIX_RUNTIME=/opt/helix/runtime

# Install Zellij
RUN curl -LO https://github.com/zellij-org/zellij/releases/latest/download/zellij-x86_64-unknown-linux-musl.tar.gz \
    && tar xzf zellij-x86_64-unknown-linux-musl.tar.gz \
    && mv zellij /usr/local/bin/ \
    && rm zellij-x86_64-unknown-linux-musl.tar.gz

# Fix ownership of dev user's home directory
RUN chown -R dev:dev /home/dev

# Trust all directories for git (needed for bind-mounted projects with different ownership)
RUN git config --system --add safe.directory '*'

# Set fish as default shell
ENV SHELL=/usr/bin/fish

# Skip Claude Code onboarding wizard (as dev user)
RUN su dev -c 'echo "{\"hasCompletedOnboarding\": true, \"theme\": \"dark\"}" > /home/dev/.claude.json'

# Helix config
RUN mkdir -p /home/dev/.config/helix && \
    printf '%s\n' \
        'theme = "gruvbox_dark_hard"' \
        > /home/dev/.config/helix/config.toml && \
    chown -R dev:dev /home/dev/.config/helix

# Fish shell config: alias + distinct color scheme for jail
RUN mkdir -p /home/dev/.config/fish && \
    printf '%s\n' \
        'fish_add_path ~/.nix-profile/bin' \
        'fish_add_path ~/.local/bin' \
        'alias claude="claude --dangerously-skip-permissions"' \
        '' \
        '# Jail color scheme - orange/red tint to distinguish from host' \
        'set -g fish_color_user ff8700' \
        'set -g fish_color_host ff5f00' \
        'set -g fish_color_cwd ffaf00' \
        'set -g fish_color_command ff8700' \
        'set -g fish_color_param d7af87' \
        'set -g fish_color_error ff0000' \
        'set -g fish_color_comment 808080' \
        'set -g fish_color_autosuggestion 585858' \
        'set -g fish_color_valid_path --underline' \
        > /home/dev/.config/fish/config.fish && \
    chown -R dev:dev /home/dev/.config/fish

# Copy entrypoint script
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

RUN mkdir -p /home/dev/cargo
ENV CARGO_HOME=/home/dev/cargo
ENV CARGO_NET_GIT_FETCH_WITH_CLI=true

# Codex install (late in the file to make updating easy enough)
RUN npm install -g @openai/codex

RUN chown -R dev:dev /home/dev

RUN mkdir -p /home/dev/.bun/install/cache && chown -R dev:dev /home/dev/.bun

WORKDIR /home/dev/project
ENTRYPOINT ["/entrypoint.sh"]
CMD ["fish"]
