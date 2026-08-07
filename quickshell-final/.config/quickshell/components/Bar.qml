import QtQuick
import Quickshell
import Quickshell.Controls as QsControls

QsControls.Surface {
    id: barSurface
    
    // Top bar surface - glass panel matching Waybar dimensions
    anchors.top: parent.top
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.margins: Catppuccin.barMargin
    
    z: 9999 // Always on top
    
    implicitHeight: Catppuccin.barHeight
    
    // Glass background matching Waybar style.css
    background: Rectangle {
        color: Catppuccin.bgTranslucent
        radius: Catppuccin.moduleRadius
        border.color: "transparent"
        
        // Hyprland blur is configured via layer_rule in windowrules.lua
        // Equivalent to: layerrule = match:namespace quickshell, blur on
    }
    
    // Three-column layout: Left | Center | Right
    RowLayout {
        anchors.fill: parent
        anchors.leftMargin: 12
        anchors.rightMargin: 12
        spacing: 8
        
        // LEFT MODULES
        RowLayout {
            Layout.alignment: Qt.AlignLeft
            spacing: 4
            
            // Updates module placeholder
            Text {
                text: " 0"
                color: Catppuccin.peach
                font.family: "JetBrainsMono Nerd Font Propo"
                font.pixelSize: 13
                font.weight: Font.Bold
            }
            
            // CPU Temp placeholder
            Text {
                text: " 45°C"
                color: Catppuccin.blue
                font.family: "JetBrainsMono Nerd Font Propo"
                font.pixelSize: 13
            }
            
            // GPU Temp placeholder
            Text {
                text: "󰢟 40°C"
                color: Catppuccin.sky
                font.family: "JetBrainsMono Nerd Font Propo"
                font.pixelSize: 13
            }
            
            // Clipboard launcher
            Text {
                text: "󰅍"
                color: Catppuccin.blue
                font.family: "JetBrainsMono Nerd Font Propo"
                font.pixelSize: 16
                
                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: Qt.openUrlExternally("wofi")
                }
            }
        }
        
        // CENTER MODULES
        RowLayout {
            Layout.alignment: Qt.AlignHCenter
            spacing: 8
            
            // Arch Logo
            Text {
                text: ""
                color: Catppuccin.blue
                font.family: "JetBrainsMono Nerd Font Propo"
                font.pixelSize: 18
                
                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: Qt.openUrlExternally("kitty")
                }
            }
            
            // Workspaces Component (event-driven via Hyprland IPC)
            Workspaces {}
        }
        
        // RIGHT MODULES
        RowLayout {
            Layout.alignment: Qt.AlignRight
            spacing: 4
            
            // Network (interrupt-driven via DBus)
            Text {
                text: networkStatus.text
                color: networkStatus.color
                font.family: "JetBrainsMono Nerd Font Propo"
                font.pixelSize: 15
                tooltip: networkStatus.tooltip
            }
            
            // Bluetooth
            Text {
                text: "󰂯"
                color: Catppuccin.blue
                font.family: "JetBrainsMono Nerd Font Propo"
                font.pixelSize: 15
            }
            
            // Notifications indicator
            Text {
                text: "󰂚"
                color: Catppuccin.blue
                font.family: "JetBrainsMono Nerd Font Propo"
                font.pixelSize: 16
            }
            
            // Volume (interrupt-driven via PulseAudio events)
            Text {
                text: volumeStatus.text
                color: Catppuccin.yellow
                font.family: "JetBrainsMono Nerd Font Propo"
                font.pixelSize: 13
            }
            
            // Battery (interrupt-driven via UPower DBus)
            Text {
                text: batteryStatus.text
                color: batteryStatus.color
                font.family: "JetBrainsMono Nerd Font Propo"
                font.pixelSize: 13
                font.weight: Font.Bold
            }
            
            // Clock
            Text {
                id: clockText
                text: Qt.formatTime(new Date(), "HH:mm")
                color: Catppuccin.text
                font.family: "JetBrainsMono Nerd Font Propo"
                font.pixelSize: 14
                font.weight: Font.Bold
                
                Timer {
                    interval: 1000
                    running: true
                    repeat: true
                    onTriggered: clockText.text = Qt.formatTime(new Date(), "HH:mm")
                }
            }
            
            // Power Button
            Text {
                text: ""
                color: Catppuccin.red
                font.family: "JetBrainsMono Nerd Font Propo"
                font.pixelSize: 15
                style: Text.Outline
                styleColor: "rgba(243, 139, 168, 0.3)"
                
                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: Qt.openUrlExternally("wlogout")
                }
            }
        }
    }
    
    // Status properties - would be bound to services in full implementation
    property var networkStatus: {"text": "󰤨", "color": Catppuccin.green, "tooltip": "WiFi: Connected"}
    property var volumeStatus: {"text": "󰕾 75%", "color": Catppuccin.yellow}
    property var batteryStatus: {"text": "󰂀 85%", "color": Catppuccin.text}
}
