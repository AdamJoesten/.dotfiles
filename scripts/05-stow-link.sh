#!/usr/bin/env bash
set -euo pipefail

# Dotfiles stowing script
# Usage: ./03-stow-link.sh pkg1 pkg2 ...

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TARGET_DIR="$HOME"

if [ $# -eq 0 ]; then
    echo "No packages provided for stowing."
    exit 0
fi

echo "=> Stowing packages: $*"
for pkg in "$@"; do
    if [ -d "$DOTFILES_DIR/$pkg" ]; then
        echo "   -> Stowing $pkg..."
        stow -t "$TARGET_DIR" -d "$DOTFILES_DIR" "$pkg"
    else
        echo "   [!] Package $pkg not found in $DOTFILES_DIR"
    fi
done

echo "=> Stowing complete."
