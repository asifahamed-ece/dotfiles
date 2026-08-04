#!/usr/bin/env bash
# Power options menu — now themed to match the glossy glass look used by
# the WiFi/Bluetooth menus.

ROFI_THEME="$HOME/.config/rofi/power-menu.rasi"
menu_theme_args=()
[ -f "$ROFI_THEME" ] && menu_theme_args=(-theme "$ROFI_THEME")

options="  Lock\n  Suspend\n  Restart\n  Shutdown\n  Logout"

chosen=$(echo -e "$options" | rofi -dmenu -i -p "Power" "${menu_theme_args[@]}")

case "$chosen" in
    *Lock*) hyprlock & ;;
    *Suspend*) systemctl suspend ;;
    *Restart*) systemctl reboot ;;
    *Shutdown*) systemctl poweroff ;;
    *Logout*) hyprctl dispatch exit ;;
esac
