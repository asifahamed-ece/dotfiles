// ~/.config/quickshell/components/Bar.qml
import QtQuick
import QtQuick.Controls

Rectangle {
    id: barBackground
    anchors.fill: parent
    color: Catppuccin.base
    opacity: 0.8

    MouseArea {
        anchors.fill: parent
        acceptedButtons: Qt.LeftButton | Qt.RightButton
        onClicked: {
            if (mouse.button === Qt.RightButton) {
                console.log("Right click on bar - show quick menu");
            }
        }
    }
}
