#!/usr/bin/env bash
set -euo pipefail

# Neovim (Unstable PPA) & Plugin Dependencies

echo "=> Syncing Neovim & Dependencies..."

# 1. External Dependencies (Kickstart Requirements)
# Note: unzip and xclip are handled by 01-apt-install.sh
# Note: rg and fd are handled by 03-cargo-install.sh
# Note: build-essential is handled by 01-apt-install.sh
NVIM_DEPS=(
    "neovim"
)

# Use our apt-cache timer logic for efficiency
LAST_UPDATE="$HOME/.cache/dotfiles/apt_update_last"
NEED_UPDATE=0

if ! command -v nvim >/dev/null 2>&1; then
    echo "   Adding Neovim PPA..."
    sudo add-apt-repository ppa:neovim-ppa/unstable -y
    NEED_UPDATE=1
fi

if [ "$NEED_UPDATE" -eq 1 ] || [ ! -f "$LAST_UPDATE" ] || [ $(($(date +%s) - $(stat -c %Y "$LAST_UPDATE"))) -gt 3600 ]; then
    sudo apt-get update -qq
    mkdir -p "$(dirname "$LAST_UPDATE")"
    touch "$LAST_UPDATE"
fi

echo "   Ensuring Neovim is installed..."
sudo apt-get install -y -qq "${NVIM_DEPS[@]}"

# 2. Modern Tree-sitter CLI (via Cargo)
# APT version is often too old for nvim-treesitter (v0.20.8 vs modern v0.24+)
if ! command -v tree-sitter >/dev/null 2>&1 || [[ $(tree-sitter --version) == *"0.20.8"* ]]; then
    echo "   Installing modern tree-sitter-cli via cargo..."
    # Ensure cargo is in path for this script
    export CARGO_HOME="${CARGO_HOME:-$HOME/.local/share/cargo}"
    export PATH="$CARGO_HOME/bin:$PATH"
    cargo install tree-sitter-cli --quiet
else
    echo "   [Skip] Modern tree-sitter-cli is already present."
fi

# 3. Language Provider Support
if command -v uv >/dev/null 2>&1; then
    echo "   Ensuring pynvim (Python provider) is available..."
    uv tool install pynvim --quiet || true
fi

echo "=> Neovim sync complete."
