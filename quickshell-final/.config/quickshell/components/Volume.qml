import QtQuick
import Quickshell.Controls as QsControls
import Quickshell.Services.PulseAudio

import "../theme"

QsControls.Surface {
    id: volumeWidget
    
    implicitHeight: Catppuccin.barHeight
    implicitWidth: volumeText.implicitWidth + 8
    
    background: Rectangle {
        color: "transparent"
    }
    
    Text {
        id: volumeText
        text: volumeService.volumeIcon + " " + volumeService.volumePercent + "%"
        color: Catppuccin.yellow
        font.family: "JetBrainsMono Nerd Font Propo"
        font.pixelSize: 13
        
        MouseArea {
            anchors.fill: parent
            cursorShape: Qt.PointingHandCursor
            onWheel: wheel => {
                if (wheel.angleDelta.y > 0) {
                    volumeService.adjustVolume(5)
                } else {
                    volumeService.adjustVolume(-5)
                }
            }
            onClicked: volumeService.toggleMute()
        }
    }
    
    // Volume Service - Event-driven via PulseAudio/PipeWire events
    QtObject {
        id: volumeService
        
        property int volumePercent: 75
        property bool muted: false
        property string volumeIcon: "󰕾"
        
        Component.onCompleted: {
            updateVolumeInfo()
        }
        
        function updateVolumeInfo() {
            // Listen to PulseAudio server change signals in production
            // pactl subscribe equivalent via DBus
        }
        
        function adjustVolume(delta: int) {
            // Use playerctl or pactl to adjust volume
            var process = Qt.createQmlProcess("pactl", ["set-sink-volume", "@DEFAULT_SINK@", (volumePercent + delta) + "%"])
            process.start()
        }
        
        function toggleMute() {
            var process = Qt.createQmlProcess("pactl", ["set-sink-mute", "@DEFAULT_SINK@", "toggle"])
            process.start()
        }
    }
}
