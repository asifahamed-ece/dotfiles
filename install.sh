#!/bin/bash
set -e
cd "$(dirname "$0")"

echo "[1/4] Installing base tools & Stow..."
sudo pacman -S --needed stow yay git

echo "[2/4] Stowing configurations..."
for p in hypr waybar kitty rofi wofi yazi imv mpv swaync btop cava htop gtk-3.0 Thunar systemd mime vscode shell; do
  [ -d "$p" ] && stow -t "$HOME" "$p"
done

echo "[3/4] Fixing hardcoded paths for this machine..."
# Replaces /home/shadow with the current user's home directory
find "$HOME/.config" -type f -exec sed -i "s|/home/shadow|$HOME|g" {} + 2>/dev/null || true

echo "[4/4] Finalizing..."
sudo usermod -aG uucp "$USER"
systemctl --user daemon-reload

echo "✅ ShadowArch Dotfiles Installed!"
echo "Please log out and log back in, or reboot."
echo "To install VS Code extensions, run: xargs -a meta/vscode-extensions.txt code --install-extension"
