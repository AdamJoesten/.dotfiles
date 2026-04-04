#!/usr/bin/env bash
set -euo pipefail

# Nerd Fonts Installation Script
# Downloads and installs 0xProto and ProggyClean Nerd Fonts for maximum legibility at small sizes.

VERSION="v3.4.0" # Pinned Nerd Fonts version
FONTS_DIR="${XDG_DATA_HOME:-$HOME/.local/share}/fonts"

# Fonts to install
FONTS=(
    "0xProto"
    "ProggyClean"
)

echo "=> Ensuring local fonts directory exists..."
mkdir -p "$FONTS_DIR"

echo "=> Installing Nerd Fonts ($VERSION)..."

for font in "${FONTS[@]}"; do
    # Idempotent check: check for a representative file
    if ls "$FONTS_DIR"/*"$font"* >/dev/null 2>&1; then
        echo "   [Skip] $font is already installed."
        continue
    fi

    echo "   -> Downloading $font..."
    TEMP_DIR=$(mktemp -d)
    ZIP_FILE="$TEMP_DIR/$font.zip"
    
    curl -fsSL "https://github.com/ryanoasis/nerd-fonts/releases/download/$VERSION/$font.zip" -o "$ZIP_FILE"
    
    echo "   -> Extracting $font..."
    unzip -q -o "$ZIP_FILE" -d "$FONTS_DIR"
    
    rm -rf "$TEMP_DIR"
    echo "   -> $font installed."
done

echo "=> Rebuilding font cache..."
if command -v fc-cache >/dev/null 2>&1; then
    fc-cache -fv "$FONTS_DIR" > /dev/null
    echo "   Font cache rebuilt."
else
    echo "   [!] fc-cache not found. Terminal restart may be required."
fi

echo "=> Fonts installation complete."
