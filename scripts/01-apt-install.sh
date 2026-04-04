#!/usr/bin/env bash
set -euo pipefail

# Foundation & Core Toolchain (LLVM Focused)

CLANG_VERSION="18"
LOCAL_BIN="$HOME/.local/bin"
mkdir -p "$LOCAL_BIN"

echo "=> Ensuring UTF-8 locale..."
if ! locale -a | grep -iq "en_US.utf8"; then
    sudo sed -i '/en_US.UTF-8/s/^# //g' /etc/locale.gen
    sudo locale-gen en_US.UTF-8
    sudo update-locale LANG=en_US.UTF-8 LC_ALL=en_US.UTF-8
fi
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

# 1. Base System Dependencies
PACKAGES=(
    "stow" "curl" "unzip" "tar" "ca-certificates" "libssl-dev"
    "build-essential" "software-properties-common" "wget" "gnupg"
    "locales" "pkg-config" "zlib1g-dev" "xclip" "unzip"
)

# 2. Apt Cache Management
CACHE_DIR="$HOME/.cache/dotfiles"
mkdir -p "$CACHE_DIR"
LAST_UPDATE="$CACHE_DIR/apt_update_last"

echo "=> Syncing system repositories..."
if [ ! -f "$LAST_UPDATE" ] || [ $(($(date +%s) - $(stat -c %Y "$LAST_UPDATE"))) -gt 3600 ]; then
    sudo apt-get update -qq
    touch "$LAST_UPDATE"
else
    echo "   [Skip] Apt cache is fresh."
fi

sudo apt-get install -y -qq "${PACKAGES[@]}"

# 3. Pinned LLVM/Clang Toolchain
if ! command -v "clang-$CLANG_VERSION" >/dev/null 2>&1; then
    echo "=> Adding LLVM $CLANG_VERSION repository..."
    CODENAME=$(lsb_release -sc)
    wget -qO- https://apt.llvm.org/llvm-snapshot.gpg.key | sudo tee /etc/apt/trusted.gpg.d/apt.llvm.org.asc > /dev/null
    sudo add-apt-repository "deb http://apt.llvm.org/${CODENAME}/ llvm-toolchain-${CODENAME}-$CLANG_VERSION main" -y
    sudo apt-get update -qq
    sudo apt-get install -y "clang-$CLANG_VERSION" "clangd-$CLANG_VERSION" "lld-$CLANG_VERSION" "lldb-$CLANG_VERSION"
fi

# 4. Canonical Symlinking (LLVM as Default)
echo "=> Establishing LLVM toolchain symlinks..."
ln -sf "/usr/bin/clang-$CLANG_VERSION" "$LOCAL_BIN/clang"
ln -sf "/usr/bin/clang-$CLANG_VERSION" "$LOCAL_BIN/cc"
ln -sf "/usr/bin/clang++-$CLANG_VERSION" "$LOCAL_BIN/clang++"
ln -sf "/usr/bin/clang++-$CLANG_VERSION" "$LOCAL_BIN/c++"
ln -sf "/usr/bin/clangd-$CLANG_VERSION" "$LOCAL_BIN/clangd"
ln -sf "/usr/bin/lld-$CLANG_VERSION" "$LOCAL_BIN/ld.lld"

echo "=> Foundation & LLVM Toolchain Sync Complete."
