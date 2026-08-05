# 🌑 ShadowArch · dotfiles

> My first Arch Linux rice — engineered like a product.
> A lightweight, keyboard-driven **Hyprland** setup for Wayland, built by an embedded-systems student who refuses to use a mouse more than necessary.

![Arch](https://img.shields.io/badge/Arch-Linux-1793d1?logo=archlinux&logoColor=white)
![Hyprland](https://img.shields.io/badge/Hyprland-Wayland-58e6ca)

---

## ✨ Philosophy

- **Lightweight first** — every app earned its place (imv over gimp-weights, zathura over heavy PDF suites).
- **Keyboard-driven** — rofi/wofi launchers, yazi file manager, vim-style everything.
- **Catppuccin soul** — gradient borders, glassy blur, consistent palette across bar, lock screen and notifications.
- **Reproducible** — one command restores the entire environment on a fresh Arch install.

## 🧩 Components

| Package | Role |
|---|---|
| `hypr` | Hyprland (Lua config): dwindle layout, gradient borders, spring animations, hyprlock badge screen, hyprpaper, custom scripts & wallpapers |
| `waybar` | Minimal tooltip-driven bar with custom module scripts (battery, temps, updates, network) |
| `rofi` / `wofi` | App launcher · emoji picker · cliphist history UI |
| `yazi` | Terminal file manager with image/video/PDF previews + Catppuccin flavor |
| `imv` | Image viewer with horizontal gallery navigation (`←`/`→`) |
| `Thunar` + `gtk-3.0` | GUI file manager with custom actions + GTK theming |
| `swaync` | Glassmorphism notification center |
| `systemd` | User services: cliphist watchers (no daemon trauma) |
| `mime` | The file-handler matrix: imv · mpv/vlc · zathura · abiword · gnumeric · xarchiver · gedit |
| `shell` | `.bashrc` with the `y()` yazi cd-on-quit wrapper |
| `vscode` | VS Code user settings + extension blueprint |
| `cava` / `htop` | Terminal eye-candy |
| `meta` | Package blueprints: `pacman`, AUR and VS Code extension lists |

## 📦 Installation

**Prerequisites:** fresh Arch Linux + Hyprland, `yay`, internet.

```bash
git clone https://github.com/asifahamed-ece/dotfiles.git ~/dotfiles
cd ~/dotfiles
./install.sh
```

`install.sh` will:
1. Install `stow` + base tooling.
2. Stow every package (symlinks into `~/.config`).
3. Rewrite hardcoded `/home/shadow` paths to **your** `$HOME`.
4. Add you to the `uucp` group (serial ports for ESP32/STM32 flashing 🔌).

Then **log out / reboot**.

**Full system rebuild (optional):**
```bash
sudo pacman -S --needed - < meta/pacman-packages.txt
yay -S --needed - < meta/aur-packages.txt
xargs -a meta/vscode-extensions.txt code --install-extension
```

**Selective install (à la carte):**
```bash
cd ~/dotfiles && stow -t ~ hypr waybar yazi   # pick only what you want
```

## ⌨️ Keybind Highlights

| Key | Action |
|---|---|
| `SUPER + SPACE` | Rofi app launcher |
| `SUPER + C` | Close window |
| `SUPER + SHIFT + H/J/K/L` | Move window left/down/up/right |
| `SUPER + M` | Toggle dwindle split |
| `SUPER + S` / `+ SHIFT + S` | Toggle / send to scratchpad (`special:magic`) |
| `SUPER + V` | **Paste clipboard image as file** (Windows-style) |
| `SUPER + SHIFT + V` | Cliphist history picker |
| `SUPER + PERIOD` | Wofi emoji picker |
| `SUPER + ESC` | Hyprlock |
| `PRINT` / `SUPER+PRINT` / `SUPER+CTRL+PRINT` | Area / full / window screenshot |
| `XF86` media keys | swayosd OSD bars + playerctl |

## 🗂️ Repository Structure

```
dotfiles/
├── .github/workflows/   # ShellCheck CI on every push
├── hypr/.config/hypr/   # compositor, lock, paper, scripts, walls
├── waybar/.config/      # bar config + module scripts
├── rofi/ wofi/          # launchers & pickers
├── yazi/ imv/           # terminal FM + image gallery
├── Thunar/ gtk-3.0/     # GUI layer
├── swaync/ systemd/     # notifications + user services
├── mime/ shell/ vscode/ # associations, bashrc, editor settings
├── cava/ htop/          # eye-candy
├── meta/                # package blueprints
├── install.sh           # one-command restore
└── SECURITY.md          # vulnerability policy
```

## 🔐 Security

See [SECURITY.md](SECURITY.md). Browser profiles, credentials and history are hard-blocked by `.gitignore` — this repo learned that lesson the hard way and healed. 😄

## 🙏 Credits

- [hyprconf2lua](https://github.com/Prateek-squadron/hyprconf2lua) — Lua config foundation
- Catppuccin — palette inspiration
- adi1090x — theme craftsmanship inspiration
- The Arch Wiki, obviously.

---

*Built with ☕ and stubbornness by **Asif Ahamed** — final-year ECE student, embedded systems enthusiast, professional green-square collector.* 🐧- [Security Policy](SECURITY.md)

