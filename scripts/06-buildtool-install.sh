#!/usr/bin/env bash
set -euo pipefail

LOCAL_BIN="$HOME/.local/bin"
LOCAL_OPT="$HOME/.local/opt"
mkdir -p "$LOCAL_BIN" "$LOCAL_OPT"

# LOCK THE VERSIONS HERE
CMAKE_VER="4.3.1"
ZIG_VER="0.15.2" # Zig provides a pinned 'zig cc' and 'zig c++' replacement for GCC

install_cmake() {
    if [[ ! -d "$LOCAL_OPT/cmake-$CMAKE_VER" ]]; then
        echo "=> Pinning CMake $CMAKE_VER..."
        local url="https://github.com/Kitware/CMake/releases/download/v$CMAKE_VER/cmake-$CMAKE_VER-linux-x86_64.tar.gz"
        curl -fsSL "$url" | tar -xz -C "$LOCAL_OPT"
        mv "$LOCAL_OPT/cmake-$CMAKE_VER-linux-x86_64" "$LOCAL_OPT/cmake-$CMAKE_VER"
    fi
    ln -sf "$LOCAL_OPT/cmake-$CMAKE_VER/bin/cmake" "$LOCAL_BIN/cmake"
}

install_zig() {
    if [[ ! -d "$LOCAL_OPT/zig-$ZIG_VER" ]]; then
        echo "=> Pinning Zig $ZIG_VER (C/C++ Compiler)..."
        local url="https://ziglang.org/download/$ZIG_VER/zig-linux-x86_64-$ZIG_VER.tar.xz"
        curl -fsSL "$url" | tar -xJ -C "$LOCAL_OPT"
        mv "$LOCAL_OPT/zig-linux-x86_64-$ZIG_VER" "$LOCAL_OPT/zig-$ZIG_VER"
    fi
    ln -sf "$LOCAL_OPT/zig-$ZIG_VER/zig" "$LOCAL_BIN/zig"
}

install_cmake &
install_zig &
wait