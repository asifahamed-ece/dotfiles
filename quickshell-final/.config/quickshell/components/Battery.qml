import QtQuick
import Quickshell.Controls as QsControls
import Quickshell.Services.Network

import "../theme"

QsControls.Surface {
    id: networkWidget
    
    implicitHeight: Catppuccin.barHeight
    implicitWidth: networkText.implicitWidth + 8
    
    background: Rectangle {
        color: "transparent"
    }
    
    Text {
        id: networkText
        text: networkService.networkIcon
        color: networkService.networkColor
        font.family: "JetBrainsMono Nerd Font Propo"
        font.pixelSize: 15
        tooltip: networkService.networkTooltip
        
        MouseArea {
            anchors.fill: parent
            cursorShape: Qt.PointingHandCursor
            onClicked: networkService.toggleMenu()
        }
    }
    
    // Network Service - Event-driven via NetworkManager DBus
    QtObject {
        id: networkService
        
        property string networkIcon: "󰤨"
        property color networkColor: Catppuccin.green
        property string networkTooltip: "WiFi: Connected"
        property bool wifiConnected: false
        property bool ethernetConnected: false
        property int signalStrength: 0
        
        Component.onCompleted: {
            updateNetworkInfo()
        }
        
        function updateNetworkInfo() {
            // Listen to NetworkManager DBus signals in production
            // This is a placeholder for the event-driven implementation
        }
        
        function toggleMenu() {
            Qt.openUrlExternally("nm-connection-editor")
        }
    }
}
