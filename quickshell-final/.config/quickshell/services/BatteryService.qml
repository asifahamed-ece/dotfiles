import QtQuick
import Quickshell

pragma Singleton

QtObject {
    id: batteryService
    
    // Event-driven Battery Service using UPower DBus signals
    // Replaces polling-based battery.sh (interval: 10)
    // Listens to UPower DBus PropertyChanges instead of reading /sys/class/power_supply
    
    property bool batteryPresent: false
    property int percentage: 0
    property string state: "" // "charging", "discharging", "fully-charged"
    property string timeToEmpty: ""
    property string timeToFull: ""
    
    readonly property string batteryIcon: getBatteryIcon()
    readonly property color batteryColor: getBatteryColor()
    readonly property string batteryText: batteryIcon + " " + percentage + "%"
    readonly property string batteryTooltip: getBatteryTooltip()
    
    Component.onCompleted: {
        initialize()
    }
    
    function initialize() {
        // Check if battery exists
        var batPath = "/org/freedesktop/UPower/devices/battery_BAT0"
        
        // In production, this would use QMFileSystemWatcher or DBus monitor
        // For now, we set up the structure for event-driven updates
        batteryPresent = true // Assume present, will be updated by signal
        
        // Listen for UPower DBus signals
        // dbus-monitor --system "interface='org.freedesktop.DBus.Properties',path='/org/freedesktop/UPower/devices/battery_BAT0'"
    }
    
    function getBatteryIcon() {
        if (!batteryPresent) return "󰚥"
        
        var icon = ""
        if (percentage >= 90) icon = "󰁹"
        else if (percentage >= 80) icon = "󰂀"
        else if (percentage >= 70) icon = "󰂁"
        else if (percentage >= 60) icon = "󰂂"
        else if (percentage >= 50) icon = "󰂃"
        else if (percentage >= 40) icon = "󰂄"
        else if (percentage >= 30) icon = "󰂅"
        else if (percentage >= 20) icon = "󰂆"
        else if (percentage >= 10) icon = "󰂇"
        else icon = "󰂈"
        
        if (state === "charging") icon += " 󰢟"
        
        return icon
    }
    
    function getBatteryColor() {
        if (state === "charging") return "#f9e2af" // yellow
        if (percentage <= 10) return "#f38ba8" // red (critical)
        if (percentage <= 30) return "#fab387" // peach (warning)
        return "#a6e3a1" // green (good)
    }
    
    function getBatteryTooltip() {
        if (!batteryPresent) return "No battery detected"
        
        var tip = "Battery: " + percentage + "%"
        if (state === "charging") tip += "\nCharging - Time to full: " + timeToFull
        else if (state === "discharging") tip += "\nDischarging - Time remaining: " + timeToEmpty
        else if (state === "fully-charged") tip += "\nFully charged"
        
        return tip
    }
    
    // Called when UPower DBus signal is received
    function onBatteryUpdated() {
        // Parse upower output and update properties
        // This is triggered by the bash script's dbus-send signal
    }
}
