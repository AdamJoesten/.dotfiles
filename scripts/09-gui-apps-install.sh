#!/usr/bin/env bash
set -euo pipefail

echo "=> Installing Third-Party GUI Applications..."

# Ensure the keyrings directory exists (modern Ubuntu standard)
sudo mkdir -p /etc/apt/keyrings

# --- 1. Google Chrome ---
if ! command -v google-chrome >/dev/null 2>&1; then
    echo "   Adding Google Chrome repository..."
    wget -qO- https://dl.google.com/linux/linux_signing_key.pub | sudo gpg --dearmor --yes -o /etc/apt/keyrings/google-chrome.gpg
    echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/google-chrome.gpg] http://dl.google.com/linux/chrome/deb/ stable main" | sudo tee /etc/apt/sources.list.d/google-chrome.list > /dev/null
else
    echo "   Google Chrome is already installed."
fi

# --- 2. Visual Studio Code ---
if ! command -v code >/dev/null 2>&1; then
    echo "   Adding VS Code repository..."
    wget -qO- https://packages.microsoft.com/keys/microsoft.asc | sudo gpg --dearmor --yes -o /etc/apt/keyrings/packages.microsoft.gpg
    echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" | sudo tee /etc/apt/sources.list.d/vscode.list > /dev/null
else
    echo "   VS Code is already installed."
fi

# --- 3. 1Password ---
if ! command -v 1password >/dev/null 2>&1; then
    echo "   Adding 1Password repository..."
    curl -sS https://downloads.1password.com/linux/keys/1password.asc | sudo gpg --dearmor --yes -o /etc/apt/keyrings/1password-archive-keyring.gpg
    echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/1password-archive-keyring.gpg] https://downloads.1password.com/linux/debian/amd64 stable main" | sudo tee /etc/apt/sources.list.d/1password.list > /dev/null
else
    echo "   1Password is already installed."
fi

# --- Install Applications ---
echo "=> Updating package lists..."
sudo apt-get update -qq

echo "=> Installing apps via apt..."
sudo apt-get install -y -qq google-chrome-stable code 1password

# --- 4. Obsidian (via Flatpak) ---
echo "=> Installing Obsidian via Flatpak..."
sudo flatpak install -y flathub md.obsidian.Obsidian

echo "=> GUI Applications installation complete."