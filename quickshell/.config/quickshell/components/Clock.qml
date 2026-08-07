// ~/.config/quickshell/components/Clock.qml
import QtQuick
import QtQuick.Controls

Item {
    id: clockContainer
    width: childrenRect.width
    height: parent.height

    Text {
        id: clockText
        text: Qt.formatTime(new Date(), "hh:mm AP")
        font.pixelSize: 16
        font.family: "JetBrainsMono Nerd Font Propo"
        color: Catppuccin.text
        anchors.verticalCenter: parent.verticalCenter

        Timer {
            id: clockTimer
            interval: 1000
            running: true
            repeat: true
            onTriggered: clockText.text = Qt.formatTime(new Date(), "hh:mm AP")
        }
    }
}
