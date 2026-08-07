// ~/.config/quickshell/components/Volume.qml
import QtQuick
import QtQuick.Controls
import Quickshell.Services

Item {
    id: volumeContainer
    width: childrenRect.width
    height: parent.height

    Row {
        anchors.verticalCenter: parent.verticalCenter
        spacing: 6

        // Volume icon using Unicode characters
        Text {
            id: volumeIcon
            text: {
                var vol = PipeWire.defaultSink?.volume ?? 0;
                var muted = PipeWire.defaultSink?.muted ?? false;
                
                if (muted || vol === 0) return "";
                else if (vol < 30) return "";
                else if (vol < 70) return "";
                else return "";
            }
            font.family: "JetBrainsMono Nerd Font Propo"
            font.pixelSize: 18
            color: Catppuccin.text
        }

        // Volume percentage text
        Text {
            text: Math.round(PipeWire.defaultSink?.volume ?? 0) + "%"
            font.pixelSize: 14
            font.family: "JetBrainsMono Nerd Font Propo"
            color: Catppuccin.text
            anchors.verticalCenter: parent.verticalCenter
        }
    }

    // Mouse area for scroll to change volume
    MouseArea {
        anchors.fill: parent
        acceptedButtons: Qt.LeftButton
        onClicked: {
            PipeWire.defaultSink.muted = !PipeWire.defaultSink.muted;
        }
        onWheel: wheel => {
            var currentVol = PipeWire.defaultSink?.volume ?? 0;
            var delta = wheel.angleDelta.y > 0 ? 0.05 : -0.05;
            PipeWire.defaultSink.volume = Math.max(0, Math.min(1, currentVol + delta));
        }
    }
}
