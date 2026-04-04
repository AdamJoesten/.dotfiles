#!/usr/bin/env bash
set -euo pipefail

RUST_VERSION="1.94.1"

RG_VERSION="15.1.0"
FD_VERSION="10.4.2"
DELTA_VERSION="0.19.2"
EZA_VERSION="0.23.4"
STARSHIP_VERSION="1.24.2"

# 1. State Reconciliation for the Rust Toolchain
# Ensure XDG-compliant paths are respected
export CARGO_HOME="${CARGO_HOME:-$HOME/.local/share/cargo}"
export RUSTUP_HOME="${RUSTUP_HOME:-$HOME/.local/share/rustup}"
mkdir -p "$CARGO_HOME" "$RUSTUP_HOME"

if ! command -v cargo >/dev/null 2>&1; then
    echo "=> Installing Rust toolchain ($RUST_VERSION)..."
    # Using --no-modify-path as we handle it via our dotfiles/hooks
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --default-toolchain "$RUST_VERSION" --no-modify-path
    source "$CARGO_HOME/env"
else
    CURRENT_RUST=$(rustc --version | awk '{print $2}')
    if [[ "$CURRENT_RUST" != "$RUST_VERSION" ]]; then
        echo "=> Rust version mismatch (found $CURRENT_RUST, want $RUST_VERSION). Updating..."
        rustup toolchain install "$RUST_VERSION"
        rustup default "$RUST_VERSION"
    fi
fi

# Ensure cargo is in the current execution path for this script session
source "$CARGO_HOME/env"

# 2. Refactored Cargo Installation Function
# $1: binary name (to check), $2: crate name (to install), $3: version
install_cargo_tool() {
    local bin_name=$1
    local crate_name=$2
    local version=$3
    
    if command -v "$bin_name" >/dev/null 2>&1; then
        # Handle cases where the version flag might differ (standard is --version)
        local current_version=$("$bin_name" --version | awk '{print $2}')
        if [[ "$current_version" == "$version" ]]; then
            echo "=> $bin_name v$version already installed."
            return 0
        fi
        echo "=> $bin_name version mismatch (found $current_version, want $version). Reinstalling..."
    fi

    echo "=> Compiling $crate_name ($bin_name) v$version..."
    cargo install "$crate_name" --version "$version" # --locked
}

# 3. Execution with Correct Crate Names
# Format: bin_name | crate_name | version
install_cargo_tool "rg" "ripgrep" "$RG_VERSION"
install_cargo_tool "fd" "fd-find" "$FD_VERSION"
install_cargo_tool "delta" "git-delta" "$DELTA_VERSION" 
install_cargo_tool "eza" "eza" "$EZA_VERSION"
install_cargo_tool "starship" "starship" "$STARSHIP_VERSION"