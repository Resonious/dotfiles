#!/bin/sh

set -e

apt-get update
apt-get install -y fish

mkdir -p "$HOME/.config/helix"
echo 'theme = "term16_dark"' > "$HOME/.config/helix/config.toml"
echo '[editor]'              >> "$HOME/.config/helix/config.toml"
echo 'true-color = true'     >> "$HOME/.config/helix/config.toml"

if command -v solargraph; then
  echo solargraph already installed
else
  gem install solargraph
fi

if command -v hx; then
  echo hx already installed. done
else
  helix=helix-24.07-x86_64-linux

  cd ~
  wget "https://github.com/helix-editor/helix/releases/download/24.07/$helix.tar.xz"
  tar -xf "$helix.tar.xz"

  ln -s "$PWD/$helix/hx" /usr/bin/hx
  ln -s "$PWD/$helix/runtime" "$HOME/.config/helix/runtime"

  echo setup done
fi
