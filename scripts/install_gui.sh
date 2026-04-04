#!/usr/bin/env bash
set -euo pipefail

echo "=> Installing Third-Party GUI Applications..."

# Ensure the keyrings directory exists (modern Ubuntu standard)
sudo mkdir -p /etc/apt/keyrings

MISSING_APPS=()
NEED_UPDATE=0

# --- 1. Google Chrome ---
if ! command -v google-chrome >/dev/null 2>&1; then
    MISSING_APPS+=("google-chrome-stable")
    if [ ! -f "/etc/apt/sources.list.d/google-chrome.list" ]; then
        echo "   Adding Google Chrome repository..."
        wget -qO- https://dl.google.com/linux/linux_signing_key.pub | sudo gpg --dearmor --yes -o /etc/apt/keyrings/google-chrome.gpg
        echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/google-chrome.gpg] http://dl.google.com/linux/chrome/deb/ stable main" | sudo tee /etc/apt/sources.list.d/google-chrome.list > /dev/null
        NEED_UPDATE=1
    fi
else
    echo "   [Skip] Google Chrome is already installed."
fi

# --- 2. Visual Studio Code ---
if ! command -v code >/dev/null 2>&1; then
    MISSING_APPS+=("code")
    if [ ! -f "/etc/apt/sources.list.d/vscode.list" ]; then
        echo "   Adding VS Code repository..."
        wget -qO- https://packages.microsoft.com/keys/microsoft.asc | sudo gpg --dearmor --yes -o /etc/apt/keyrings/packages.microsoft.gpg
        echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" | sudo tee /etc/apt/sources.list.d/vscode.list > /dev/null
        NEED_UPDATE=1
    fi
else
    echo "   [Skip] VS Code is already installed."
fi

# --- 3. 1Password ---
if ! command -v 1password >/dev/null 2>&1; then
    MISSING_APPS+=("1password")
    if [ ! -f "/etc/apt/sources.list.d/1password.list" ]; then
        echo "   Adding 1Password repository..."
        curl -sS https://downloads.1password.com/linux/keys/1password.asc | sudo gpg --dearmor --yes -o /etc/apt/keyrings/1password-archive-keyring.gpg
        echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/1password-archive-keyring.gpg] https://downloads.1password.com/linux/debian/amd64 stable main" | sudo tee /etc/apt/sources.list.d/1password.list > /dev/null
        NEED_UPDATE=1
    fi
else
    echo "   [Skip] 1Password is already installed."
fi

# --- Install Missing APT Applications ---
if [ ${#MISSING_APPS[@]} -gt 0 ]; then
    LAST_UPDATE="$HOME/.cache/dotfiles/apt_update_last"
    if [ "$NEED_UPDATE" -eq 1 ] || [ ! -f "$LAST_UPDATE" ] || [ $(($(date +%s) - $(stat -c %Y "$LAST_UPDATE"))) -gt 3600 ]; then
        echo "=> Syncing system repositories..."
        sudo apt-get update -qq
        mkdir -p "$(dirname "$LAST_UPDATE")"
        touch "$LAST_UPDATE"
    fi

    echo "=> Installing missing apps via apt: ${MISSING_APPS[*]}..."
    sudo apt-get install -y -qq "${MISSING_APPS[@]}"
fi

# --- 4. Obsidian (via Flatpak) ---
if flatpak list --columns=application | grep -q "md.obsidian.Obsidian"; then
    echo "   [Skip] Obsidian is already installed via Flatpak."
else
    echo "=> Installing Obsidian via Flatpak..."
    sudo flatpak install -y flathub md.obsidian.Obsidian
fi

echo "=> GUI Applications sync complete."
