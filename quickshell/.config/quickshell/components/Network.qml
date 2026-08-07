// ~/.config/quickshell/components/Network.qml
import QtQuick
import QtQuick.Controls
import Quickshell.Services

Item {
    id: networkContainer
    width: childrenRect.width
    height: parent.height

    Row {
        anchors.verticalCenter: parent.verticalCenter
        spacing: 6

        // Network icon using Unicode characters
        Text {
            id: networkIcon
            text: {
                if (!NetworkManager.primaryConnection || NetworkManager.primaryConnection.state !== "activated") return "󰤭";
                
                var type = NetworkManager.primaryConnection.type;
                var strength = NetworkManager.primaryConnection.strength;
                
                if (type === "wireless") {
                    if (strength >= 80) return "󰤨";
                    else if (strength >= 60) return "󰤥";
                    else if (strength >= 40) return "󰤢";
                    else if (strength >= 20) return "󰤟";
                    else return "󰤯";
                } else if (type === "wired") {
                    return "󰈀";
                } else {
                    return "󰤭";
                }
            }
            font.family: "JetBrainsMono Nerd Font Propo"
            font.pixelSize: 18
            color: {
                if (!NetworkManager.primaryConnection || NetworkManager.primaryConnection.state !== "activated") return Catppuccin.red;
                return Catppuccin.green;
            }
        }

        // Network name/text
        Text {
            text: {
                if (!NetworkManager.primaryConnection || NetworkManager.primaryConnection.state !== "activated") return "No Connection";
                return NetworkManager.primaryConnection.name || "Connected";
            }
            font.pixelSize: 14
            font.family: "JetBrainsMono Nerd Font Propo"
            color: Catppuccin.text
            anchors.verticalCenter: parent.verticalCenter
            maximumLineCount: 1
            elide: Text.ElideRight
            width: 120
        }
    }
}
