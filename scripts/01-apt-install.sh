#!/usr/bin/env bash
set -euo pipefail

CLANG_VERSION="18"

echo "=> Ensuring UTF-8 locale..."
if ! locale -a | grep -iq "en_US.utf8"; then
    echo "   Uncommenting en_US.UTF-8 in /etc/locale.gen..."
    sudo sed -i '/en_US.UTF-8/s/^# //g' /etc/locale.gen
    sudo locale-gen en_US.UTF-8
    
    # Set it as the default system locale
    sudo update-locale LANG=en_US.UTF-8 LC_ALL=en_US.UTF-8
fi

# Export it for the current script's runtime just in case later tools (like rustup) need it
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

# Base System Dependencies
PACKAGES=(
    "stow"
    "curl"
    "unzip"
    "tar"
    "ca-certificates"
    "libssl-dev"
    "build-essential"            # For compiling C/C++ tools
    "software-properties-common" # Required for add-apt-repository
    "wget"                       # Required for LLVM GPG key
    "gnupg"                      # Added for modern keyring management
    "locales"                    # Required to enforce UTF-8 terminal rendering
    "pkg-config"                 # C-binding locator (allows Rust/Go to find system headers during compilation)
    "zlib1g-dev"                 # Zlib development headers (required to compile libgit2/git-delta)
)

echo "=> Syncing system repositories..."
sudo apt-get update -qq
sudo apt-get install -y -qq "${PACKAGES[@]}"

# Pinned LLVM/Clang Toolchain
if ! command -v "clang-$CLANG_VERSION" >/dev/null 2>&1; then
    CODENAME=$(lsb_release -sc)
    wget -qO- https://apt.llvm.org/llvm-snapshot.gpg.key | sudo tee /etc/apt/trusted.gpg.d/apt.llvm.org.asc > /dev/null
    sudo add-apt-repository "deb http://apt.llvm.org/${CODENAME}/ llvm-toolchain-${CODENAME}-$CLANG_VERSION main" -y
    sudo apt-get update -qq
    sudo apt-get install -y "clang-$CLANG_VERSION" "clangd-$CLANG_VERSION"
    
    ln -sf "/usr/bin/clang-$CLANG_VERSION" "$HOME/.local/bin/clang"
    ln -sf "/usr/bin/clang-$CLANG_VERSION" "$HOME/.local/bin/cc"
    ln -sf "/usr/bin/clang++-$CLANG_VERSION" "$HOME/.local/bin/clang++"
    ln -sf "/usr/bin/clang++-$CLANG_VERSION" "$HOME/.local/bin/c++"
    ln -sf "/usr/bin/clangd-$CLANG_VERSION" "$HOME/.local/bin/clangd"
fi

echo "=> Foundation Done."