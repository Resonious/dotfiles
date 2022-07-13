#!/bin/sh

# This script is intended for GitHub Codespaces: https://docs.github.com/en/codespaces/customizing-your-codespace/personalizing-codespaces-for-your-account#dotfiles

SCRIPT_DIR=$(dirname "$0")

# always make backups before doing copies, haha..
cp "$HOME/.bashrc" "$HOME/.bashrc.bak"
cp "$SCRIPT_DIR/bash/bashrc-server" "$HOME/.bashrc"
