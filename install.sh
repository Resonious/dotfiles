#!/bin/sh

# This script is intended for GitHub Codespaces: https://docs.github.com/en/codespaces/customizing-your-codespace/personalizing-codespaces-for-your-account#dotfiles

SCRIPT_DIR=$(dirname "$0")

# Bashrc
cp "$HOME/.bashrc" "$HOME/.bashrc.bak"
cp "$SCRIPT_DIR/bash/bashrc-server" "$HOME/.bashrc"

# Neovim setup
mkdir -p $HOME/.config/nvim
cp "$SCRIPT_DIR/neovim/init.vim" "$HOME/.config/nvim/init.vim"

sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'

# FZF setup
#
