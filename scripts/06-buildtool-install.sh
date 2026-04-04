#!/usr/bin/env bash
set -euo pipefail

# Build Tool Pinning Script (CMake & Zig)
# Pure XDG Compliant Architecture

LOCAL_BIN="$HOME/.local/bin"
XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
mkdir -p "$LOCAL_BIN" "$XDG_DATA_HOME"

# LOCK THE VERSIONS HERE
CMAKE_VER="4.3.1"
ZIG_VER="0.15.2"

# Helper to check version
check_version() {
    local bin_path=$1
    local expected=$2
    
    if [ -x "$bin_path" ]; then
        local current=$("$bin_path" version 2>/dev/null || "$bin_path" --version 2>/dev/null | head -n1 | grep -oE "[0-9]+\.[0-9]+\.[0-9]+")
        if [[ "$current" == *"$expected"* ]]; then
            return 0
        fi
    fi
    return 1
}

install_cmake() {
    local target_dir="$XDG_DATA_HOME/cmake-$CMAKE_VER"
    local bin_path="$target_dir/bin/cmake"

    if check_version "$bin_path" "$CMAKE_VER"; then
        echo "   [Skip] CMake $CMAKE_VER is already pinned (XDG)."
    else
        echo "=> Pinning CMake $CMAKE_VER (XDG)..."
        rm -rf "$target_dir"
        local url="https://github.com/Kitware/CMake/releases/download/v$CMAKE_VER/cmake-$CMAKE_VER-linux-x86_64.tar.gz"
        curl -fsSL "$url" | tar -xz -C "$XDG_DATA_HOME"
        mv "$XDG_DATA_HOME/cmake-$CMAKE_VER-linux-x86_64" "$target_dir"
    fi
    ln -sf "$bin_path" "$LOCAL_BIN/cmake"
}

install_zig() {
    local target_dir="$XDG_DATA_HOME/zig-$ZIG_VER"
    local bin_path="$target_dir/zig"

    if check_version "$bin_path" "$ZIG_VER"; then
        echo "   [Skip] Zig $ZIG_VER is already pinned (XDG)."
    else
        echo "=> Pinning Zig $ZIG_VER (XDG)..."
        rm -rf "$target_dir"
        local url="https://ziglang.org/download/$ZIG_VER/zig-linux-x86_64-$ZIG_VER.tar.xz"
        curl -fsSL "$url" | tar -xJ -C "$XDG_DATA_HOME"
        mv "$XDG_DATA_HOME/zig-linux-x86_64-$ZIG_VER" "$target_dir"
    fi
    ln -sf "$bin_path" "$LOCAL_BIN/zig"
}

echo "=> Syncing C/C++ Build Ecosystem..."
install_cmake &
install_zig &
wait

echo "=> Build toolchain sync complete (XDG Aligned)."
