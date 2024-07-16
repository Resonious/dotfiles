#!/bin/sh

set -e

apt-get update
apt-get install -y fish

if command -v &> /dev/null; then
  echo hx already installed. done
else
  helix=helix-24.07-x86_64-linux

  cd ~
  wget "https://github.com/helix-editor/helix/releases/download/24.07/$helix.tar.xz"
  tar -xf "$helix.tar.xz"

  mkdir -p "$HOME/.config/helix"

  ln -s "$PWD/$helix/hx" /usr/bin/hx
  ln -s "$PWD/$helix/runtime" "$HOME/.config/helix/runtime"

  echo setup done
fi
