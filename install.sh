#!/bin/sh

# This script is intended for GitHub Codespaces: https://docs.github.com/en/codespaces/customizing-your-codespace/personalizing-codespaces-for-your-account#dotfiles

SCRIPT_DIR=$(dirname "$0")
exec $SCRIPT_DIR/container-setup/inner.sh
