FROM debian:bookworm-slim

# Avoid prompts during package installation
ENV DEBIAN_FRONTEND=noninteractive

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
    ruby \
    ruby-dev \
    openjdk-17-jre-headless \
    && rm -rf /var/lib/apt/lists/*

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

# Install Claude Code (native build for syntax highlighting, fallback to npm)
RUN curl -fsSL --retry 5 --retry-delay 5 https://claude.ai/install.sh | bash \
    || npm install -g @anthropic-ai/claude-code

# Install Zellij
RUN curl -LO https://github.com/zellij-org/zellij/releases/latest/download/zellij-x86_64-unknown-linux-musl.tar.gz \
    && tar xzf zellij-x86_64-unknown-linux-musl.tar.gz \
    && mv zellij /usr/local/bin/ \
    && rm zellij-x86_64-unknown-linux-musl.tar.gz

# Set up Neovim config directory and copy init.lua
RUN mkdir -p /root/.config/nvim
COPY nvim/init.lua /root/.config/nvim/init.lua

# Trust all directories for git (needed for bind-mounted projects with different ownership)
RUN git config --global --add safe.directory /root/project

# Set fish as default shell
ENV SHELL=/usr/bin/fish

WORKDIR /root/project

# Set default command
CMD ["fish"]
