#!/usr/bin/env bash
set -euo pipefail

# Fast Node Manager (fnm) & pnpm installation workflow

# 1. Variables
LOCAL_BIN="$HOME/.local/bin"
XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"
FNM_DIR="$XDG_DATA_HOME/fnm"
PNPM_HOME="$XDG_DATA_HOME/pnpm"
NPM_CONFIG_DIR="$XDG_CONFIG_HOME/npm"
NPM_CACHE_DIR="$XDG_CACHE_HOME/npm"

mkdir -p "$LOCAL_BIN" "$FNM_DIR" "$PNPM_HOME" "$NPM_CONFIG_DIR" "$NPM_CACHE_DIR"

# 2. Install fnm (Fast Node Manager)
if ! command -v fnm >/dev/null 2>&1; then
    echo "=> Installing fnm (Fast Node Manager)..."
    # Using the official installer script, overriding the install directory to our local bin
    # We skip shell modification because we handle it via our dotfiles/hooks
    curl -fsSL https://fnm.vercel.app/install | bash -s -- --install-dir "$LOCAL_BIN" --skip-shell
else
    echo "=> fnm is already installed. Skipping."
fi

# 2. Sync Environment
# RESTORED: --use-on-cd is back for architectural consistency
export PATH="$LOCAL_BIN:$PATH"
eval "$(fnm env --use-on-cd --shell bash)"

# npm XDG initialization
npm config set cache "$NPM_CACHE_DIR" --global
npm config set userconfig "$NPM_CONFIG_DIR/npmrc" --global

# 3. Install & Use Node.js (Version Sensing)
echo "=> Ensuring Node.js (LTS) is configured..."

# We resolve the string first to prevent the 'fnm use --lts' parser error
LTS_VERSION=$(fnm ls-remote --lts | awk 'END {print $1}')

if ! fnm ls | grep -q "$LTS_VERSION"; then
    echo "   Installing $LTS_VERSION..."
    fnm install "$LTS_VERSION"
else
    echo "   $LTS_VERSION is already present."
fi

# Set the default and activate it
fnm default "$LTS_VERSION"
fnm use default

# 4. Enable Corepack & pnpm (XDG Aligned)
echo "=> Aligning Corepack shims with XDG architecture..."
npm install -g corepack@latest --quiet
corepack enable --install-directory "$PNPM_HOME" pnpm

# 5. Global Tools
echo "=> Syncing global CLI tools..."
pnpm install -g @google/gemini-cli --silent

# 7. Verification
echo "=> Verifying installations:"
echo "fnm:  $(which fnm) $(fnm --version)"
echo "node: $(which node) $(node --version)"
echo "pnpm: $(which pnpm) $(pnpm --version)"
echo "gemini: $(which gemini) $(gemini --version)"

echo "=> Node.js & pnpm workflow complete."
