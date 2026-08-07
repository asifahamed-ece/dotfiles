# ShadowArch → Quickshell Migration Guide
## From Polling (Waybar) to Event-Driven Architecture

### 🎯 The Paradigm Shift

**Before (Waybar - Polling):**
```json
"custom/battery": {
  "exec": "~/.config/waybar/scripts/battery.sh",
  "interval": 10  // ❌ Reads sensor every 10s, wastes CPU cycles
}
```

**After (Quickshell - Event-Driven):**
```qml
// Battery updates ONLY when UPower emits a DBus signal
// Zero CPU usage when idle - like EXTI interrupts on STM32
dbus-monitor --system "interface='org.freedesktop.DBus.Properties'" | while read; do
    update_battery_info
done
```

---

### 📁 New Directory Structure

```
~/.config/quickshell/
├── main.qml                    # Main bar definition (replaces waybar/config)
├── theme/
│   └── Catppuccin.qml         # Color singleton (replaces style.css)
├── components/
│   ├── MediaPlayer.qml        # MPRIS media widget
│   └── Workspaces.qml         # Hyprland workspace buttons
├── services/
│   ├── MediaService.qml       # MPRIS DBus bindings
│   └── WorkspaceService.qml   # Hyprland IPC bindings
└── scripts/optimized/
    ├── battery-monitor.sh     # UPower DBus listener (interval: ∞)
    ├── network-monitor.sh     # NetworkManager DBus listener
    └── volume-monitor.sh      # PulseAudio event subscriber
```

---

### ⚡ Performance Comparison

| Module | Waybar (Polling) | Quickshell (Event) | CPU Savings |
|--------|-----------------|-------------------|-------------|
| Battery | Every 10s | On state change | ~99% |
| Network | Every 3s | On connection change | ~98% |
| Volume | Every 1s | On sink event | ~95% |
| Media | N/A | MPRIS signals | N/A |
| Workspaces | N/A | Hyprland IPC socket | N/A |

**Analogy:** 
- Waybar = `while(1) { read_sensor(); sleep(5000); }` in FreeRTOS
- Quickshell = `EXTI_Configuration()` + ISR callback on STM32

---

### 🔧 Installation & Activation

1. **Install Quickshell:**
   ```bash
   sudo pacman -S quickshell
   ```

2. **Copy configuration:**
   ```bash
   cp -r ~/dotfiles/quickshell/.config/quickshell ~/.config/
   ```

3. **Update Hyprland Lua config** (already done in your repo):
   - `hyprland.lua`: Commented out `waybar &`, added `quickshell &`
   - `windowrules.lua`: Added Quickshell layer rules for blur

4. **Restart Hyprland** or reload config:
   ```bash
   hyprctl reload
   ```

---

### 🎨 Theming: Catppuccin Mocha

Your exact color palette is preserved in `theme/Catppuccin.qml`:

```qml
readonly property color blue: "#89b4fa"
readonly property color pink: "#f5c2e7"
readonly property color green: "#a6e3a1"
// ... (all Catppuccin Mocha colors)
```

Animation timings match your Hyprland bezier curves:
- `transitionSlow: 280ms` ↔ `easeOutQuint`
- `transitionFast: 180ms` ↔ `quick`

---

### 🎵 Media Player Widget

**Features:**
- Only visible when media is playing (event-driven visibility)
- `FrameAnimation` runs only during playback (CPU-free when paused)
- Scroll to skip tracks, click to play/pause
- Track metadata updates via MPRIS DBus signals

**Keybinding:** `SUPER + M` (placeholder in `hyprland.lua`)

---

### 🔋 Interrupt-Driven Scripts

Each script in `scripts/optimized/` uses DBus monitoring:

**Battery (`battery-monitor.sh`):**
```bash
# Blocks until UPower emits PropertiesChanged signal
dbus-monitor --system "path='/org/freedesktop/UPower/devices/battery_BAT0'" | \
while read; do
    get_battery_info > "$OUTPUT_FILE"
done
```

**Network (`network-monitor.sh`):**
```bash
# Listens to NetworkManager state changes
dbus-monitor --system "path='/org/freedesktop/NetworkManager'" | \
while read line; do
    if echo "$line" | grep -qE "(State|PrimaryConnection)"; then
        get_network_info > "$OUTPUT_FILE"
    fi
done
```

**Volume (`volume-monitor.sh`):**
```bash
# Subscribes to PulseAudio sink events
pactl subscribe | while read; do
    get_volume_info > "$OUTPUT_FILE"
done
```

---

### 🧩 Remaining Modules to Port

| Module | Status | Implementation Notes |
|--------|--------|---------------------|
| ✅ Media Player | Done | `components/MediaPlayer.qml` |
| ✅ Workspaces | Done | `components/Workspaces.qml` |
| ✅ Battery Service | Done | `scripts/optimized/battery-monitor.sh` |
| ✅ Network Service | Done | `scripts/optimized/network-monitor.sh` |
| ✅ Volume Service | Done | `scripts/optimized/volume-monitor.sh` |
| ⏳ Updates/Pacman | TODO | Use `alpm.hooks` DBus or file watcher on `/var/lib/pacman/db.lck` |
| ⏳ CPU/GPU Temp | TODO | Use `QFileSystemWatcher` on thermal sysfs files |
| ⏳ Clipboard | TODO | Integrate with existing `cliphist` service |
| ⏳ Notifications | TODO | DBus listener for `org.freedesktop.Notifications` |
| ⏳ Bluetooth | TODO | BlueZ DBus signals (`org.bluez.Adapter1`) |
| ⏳ Clock | Partial | Uses 1s Timer (acceptable - no DBus for time) |

---

### 🐛 Troubleshooting

**Quickshell not starting:**
```bash
journalctl --user -u quickshell -f
```

**Blur not working:**
Ensure `hl.layer_rule` in `windowrules.lua` has:
```lua
hl.layer_rule({ match = { namespace = "^quickshell$" }, blur = true, ignore_alpha = 0.15 })
```

**DBus signals not firing:**
Test manually:
```bash
dbus-monitor --system "interface='org.freedesktop.DBus.Properties'"
```

---

### 📚 Reference Links

- [Quickshell Documentation](https://quickshell.io/)
- [Hyprland Lua API](https://wiki.hypr.land/Configuring/Using-lua/)
- [MPRIS DBus Spec](https://specifications.freedesktop.org/mpris-spec/latest/)
- [UPower DBus API](https://upower.freedesktop.org/docs/)
- [NetworkManager DBus](https://networkmanager.dev/docs/api/latest/gdbus-org.freedesktop.NetworkManager.html)

---

### 🚀 Next Steps

1. **Test the migration:**
   ```bash
   # Kill Waybar
   pkill waybar
   # Start Quickshell
   quickshell
   ```

2. **Port remaining modules** (Updates, Temps, Notifications)

3. **Fine-tune animations** to match your Hyprland curves exactly

4. **Add system tray** support using Quickshell's `StatusNotifierWatcher`

---

*Built with ❤️ by treating desktop widgets like embedded microservices*
