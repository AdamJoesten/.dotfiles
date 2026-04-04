#!/usr/bin/env bash
set -euo pipefail

echo "=> Establishing Local Filesystem..."

DIRS=(
    "$HOME/.local/bin"
    "$HOME/.local/share"
    "$HOME/.local/state"
    "$HOME/.config"
    "$HOME/.cache"
)

for dir in "${DIRS[@]}"; do
    if [ ! -d "$dir" ]; then
        echo "   Creating $dir..."
        mkdir -p "$dir"
    fi
done

echo "=> Filesystem Foundation Done."
