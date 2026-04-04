#!/usr/bin/env bash
set -euo pipefail

# 1. Variables
PYTHON_VERSION="3.13"
LOCAL_BIN="$HOME/.local/bin"

echo "=> Installing Python toolchain (uv)..."

# 2. Install uv
if ! command -v uv >/dev/null 2>&1; then
    echo "   Downloading and installing uv..."
    curl -LsSf https://astral.sh/uv/install.sh | INSTALL_DIR="$LOCAL_BIN" sh -s -- --no-modify-path
    # Ensure uv is in the path for the rest of this script
    export PATH="$LOCAL_BIN:$PATH"
else
    echo "   uv is already installed. Updating..."
    uv self update || true
fi

# 3. Install & Pin Python Version
echo "=> Ensuring Python $PYTHON_VERSION is configured..."
uv python install "$PYTHON_VERSION"

echo "=> Python toolchain installation complete."
