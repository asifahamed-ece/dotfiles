// ~/.config/quickshell/shell.qml
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

ApplicationWindow {
    id: mainWindow
    width: Screen.desktopAvailableWidth
    height: 40
    x: 0
    y: 0
    flags: Qt.WindowStaysOnTopHint | Qt.FramelessWindowHint | Qt.WindowDoesNotAcceptFocus
    color: "transparent"

    Item {
        anchors.fill: parent

        RowLayout {
            anchors.fill: parent

            // Left side components
            Item {
                Layout.preferredWidth: mainWindow.width * 0.3
                Layout.fillHeight: true

                Row {
                    anchors.fill: parent
                    spacing: 10

                    Workspaces { }
                    MediaPlayer { }
                }
            }

            // Center (empty space)
            Item {
                Layout.fillWidth: true
                Layout.fillHeight: true
            }

            // Right side components
            Item {
                Layout.preferredWidth: mainWindow.width * 0.3
                Layout.fillHeight: true

                Row {
                    anchors.fill: parent
                    anchors.rightMargin: 10
                    spacing: 15

                    Volume { }
                    Network { }
                    Battery { }
                    Clock { }
                }
            }
        }

        Bar { }
    }
}
