#!/usr/bin/env bash
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
RULES_FILE="$DOTFILES_DIR/hardware/zsa/50-zsa.rules"
TARGET_FILE="/etc/udev/rules.d/50-zsa.rules"

echo "=> Setting up ZSA keyboard udev rules..."

if [ ! -f "$RULES_FILE" ]; then
    echo "Error: Rules file not found at $RULES_FILE"
    exit 1
fi

echo "   Requesting sudo privileges to copy rules to /etc/udev/rules.d/..."
sudo cp "$RULES_FILE" "$TARGET_FILE"
sudo chown root:root "$TARGET_FILE"
sudo chmod 644 "$TARGET_FILE"

echo "   Reloading udev rules..."
sudo udevadm control --reload-rules
sudo udevadm trigger

echo "   Ensuring user is in 'plugdev' group..."
if ! getent group plugdev >/dev/null; then
    sudo groupadd plugdev
fi
sudo usermod -aG plugdev "$USER"

echo "=> ZSA udev rules successfully installed."
echo "   Note: You may need to log out and log back in for the 'plugdev' group change to take effect."
