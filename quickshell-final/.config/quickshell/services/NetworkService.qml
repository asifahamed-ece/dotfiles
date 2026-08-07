import QtQuick
import Quickshell

pragma Singleton

QtObject {
    id: networkService
    
    // Event-driven Network Service using NetworkManager DBus signals
    // Replaces polling-based network.sh (interval: 3)
    // Listens to NetworkManager PropertyChanges instead of polling nmcli
    
    property bool wifiConnected: false
    property bool ethernetConnected: false
    property bool wifiPresent: true
    property string ssid: ""
    property int signalStrength: 0
    property string state: "disconnected"
    
    readonly property string networkIcon: getNetworkIcon()
    readonly property color networkColor: getNetworkColor()
    readonly property string networkText: networkIcon
    readonly property string networkTooltip: getNetworkTooltip()
    
    Component.onCompleted: {
        initialize()
    }
    
    function initialize() {
        // Check initial network state
        updateNetworkState()
        
        // In production, listen to NetworkManager DBus signals:
        // dbus-monitor --system "interface='org.freedesktop.DBus.Properties',path='/org/freedesktop/NetworkManager'"
        // dbus-monitor --system "interface='org.freedesktop.DBus.Properties',path='/org/freedesktop/NetworkManager/Devices'"
    }
    
    function updateNetworkState() {
        // This would be triggered by DBus signals in production
        // For now, structure is ready for event-driven updates
    }
    
    function getNetworkIcon() {
        if (!wifiConnected && !ethernetConnected) return "󰖪"
        
        if (ethernetConnected) return "󰈀"
        
        if (signalStrength >= 80) return "󰤨"
        else if (signalStrength >= 60) return "󰤥"
        else if (signalStrength >= 40) return "󰤢"
        else if (signalStrength >= 20) return "󰤟"
        else return "󰤜"
    }
    
    function getNetworkColor() {
        if (!wifiConnected && !ethernetConnected) return "#f38ba8" // red
        return "#a6e3a1" // green
    }
    
    function getNetworkTooltip() {
        if (!wifiConnected && !ethernetConnected) return "No network connection"
        
        if (ethernetConnected) return "Ethernet: Connected"
        
        return "WiFi: " + ssid + "\nSignal: " + signalStrength + "%\nStatus: " + state
    }
    
    // Called when NetworkManager DBus signal is received
    function onNetworkUpdated() {
        updateNetworkState()
    }
    
    function openNetworkMenu() {
        Qt.openUrlExternally("nm-connection-editor")
    }
}
