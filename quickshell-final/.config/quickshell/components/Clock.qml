import QtQuick
import Quickshell.Controls as QsControls

import "../theme"

QsControls.Surface {
    id: clockWidget
    
    implicitHeight: Catppuccin.barHeight
    implicitWidth: clockText.implicitWidth + 8
    
    background: Rectangle {
        color: "transparent"
    }
    
    Text {
        id: clockText
        text: Qt.formatTime(new Date(), "HH:mm")
        color: Catppuccin.text
        font.family: "JetBrainsMono Nerd Font Propo"
        font.pixelSize: 14
        font.weight: Font.Bold
        
        MouseArea {
            anchors.fill: parent
            cursorShape: Qt.PointingHandCursor
            onClicked: Qt.openUrlExternally("kitty -e calcurse")
        }
        
        // Timer for clock update - only this uses polling (once per second is acceptable)
        Timer {
            interval: 1000
            running: true
            repeat: true
            onTriggered: clockText.text = Qt.formatTime(new Date(), "HH:mm")
        }
    }
}
