#!/usr/bin/env bash
set -euo pipefail

echo "=> Setting up Flatpak..."

if ! command -v flatpak >/dev/null 2>&1; then
    echo "   Installing Flatpak via apt..."
    sudo apt-get update -qq
    sudo apt-get install -y -qq flatpak
    sudo apt-get install gnome-software-plugin-flatpak
else
    echo "   Flatpak is already installed."
fi

echo "   Adding Flathub repository..."
sudo flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo

echo "=> Flatpak setup complete."
echo "   Note: You may need to restart your machine for changes to take effect."

