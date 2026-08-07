// ~/.config/quickshell/components/Battery.qml
import QtQuick
import QtQuick.Controls
import Quickshell.Services

Item {
    id: batteryContainer
    width: childrenRect.width
    height: parent.height

    Row {
        anchors.verticalCenter: parent.verticalCenter
        spacing: 6

        // Battery icon using Unicode characters
        Text {
            id: batteryIcon
            text: {
                if (PowerManagement.batteries.length === 0) return "";
                var battery = PowerManagement.batteries[0];
                if (battery.percentage >= 90) return "";
                else if (battery.percentage >= 75) return "";
                else if (battery.percentage >= 50) return "";
                else if (battery.percentage >= 25) return "";
                else return "";
            }
            font.family: "JetBrainsMono Nerd Font Propo"
            font.pixelSize: 18
            color: {
                if (PowerManagement.batteries.length === 0) return Catppuccin.text;
                var battery = PowerManagement.batteries[0];
                if (battery.percentage < 20) return Catppuccin.red;
                else if (battery.percentage < 40) return Catppuccin.yellow;
                else return Catppuccin.green;
            }
        }

        // Battery percentage text
        Text {
            text: PowerManagement.batteries.length > 0 ? Math.round(PowerManagement.batteries[0].percentage) + "%" : ""
            font.pixelSize: 14
            font.family: "JetBrainsMono Nerd Font Propo"
            color: {
                if (PowerManagement.batteries.length === 0) return Catppuccin.text;
                var battery = PowerManagement.batteries[0];
                if (battery.percentage < 20) return Catppuccin.red;
                else return Catppuccin.text;
            }
            anchors.verticalCenter: parent.verticalCenter
        }

        // Charging indicator
        Text {
            visible: PowerManagement.batteries.length > 0 && PowerManagement.batteries[0].charging
            text: ""
            font.family: "JetBrainsMono Nerd Font Propo"
            font.pixelSize: 16
            color: Catppuccin.yellow
            anchors.verticalCenter: parent.verticalCenter
        }
    }
}
