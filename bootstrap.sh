#!/usr/bin/env bash
set -euo pipefail

# Dotfiles Bootstrap Script
# This is the single entry point for a fresh machine.

echo "=> Starting Dotfiles Bootstrap..."

# 1. Check for required bootstrap tools
if ! command -v make >/dev/null 2>&1 || ! command -v stow >/dev/null 2>&1; then
    echo "=> Installing bootstrap requirements (make, stow)..."
    sudo apt-get update -qq
    sudo apt-get install -y -qq make stow
fi

# 2. Run the Makefile
echo "=> Handing off to Makefile..."
make all

echo "=> Bootstrap complete. Your environment is ready."
