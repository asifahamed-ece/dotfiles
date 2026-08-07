import QtQuick
import QtQuick.Layouts
import Quickshell.Controls as QsControls

import "../theme"
import "../services"

QsControls.Surface {
    id: workspaceBar
    
    implicitHeight: Catppuccin.barHeight + 8
    implicitWidth: workspaceRow.implicitWidth + 16
    
    // Glass module styling
    background: Rectangle {
        color: "transparent"
        radius: 0
    }
    
    RowLayout {
        id: workspaceRow
        anchors.centerIn: parent
        spacing: 4
        
        Repeater {
            model: 10 // Workspaces 1-10 (matching keybindings.lua)
            
            QsControls.Surface {
                id: wsDelegate
                
                property int wsId: index + 1
                property bool isActive: WorkspaceService.activeWorkspace && WorkspaceService.activeWorkspace.id === wsId
                property bool hasWindows: WorkspaceService.workspaces.some(ws => ws.id === wsId && ws.windows > 0)
                
                implicitHeight: 32
                implicitWidth: 36
                
                background: Rectangle {
                    color: wsDelegate.isActive ? Catppuccin.blue : Catppuccin.moduleBg
                    border.color: wsDelegate.isActive ? Catppuccin.blue : "transparent"
                    border.width: 1
                    radius: 10
                    
                    Behavior on color {
                        ColorAnimation { duration: Catppuccin.transitionFast }
                    }
                    
                    Behavior on border.color {
                        ColorAnimation { duration: Catppuccin.transitionFast }
                    }
                    
                    // Subtle glow for active workspace
                    layer.enabled: wsDelegate.isActive
                    layer.effect: Glow {
                        radius: 8
                        samples: 16
                        color: Catppuccin.blue
                        opacity: 0.55
                    }
                }
                
                contentItem: Text {
                    text: wsId.toString()
                    color: wsDelegate.isActive ? Catppuccin.mantle : Catppuccin.text
                    font.family: "JetBrainsMono Nerd Font Propo"
                    font.pixelSize: 12
                    font.weight: wsDelegate.isActive ? Font.Bold : Font.Normal
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
                
                MouseArea {
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    
                    onClicked: WorkspaceService.focus({workspace: wsDelegate.wsId})
                    
                    onWheel: wheel => {
                        if (wheel.angleDelta.y > 0) {
                            WorkspaceService.focus({workspace: Math.min(10, wsDelegate.wsId + 1)})
                        } else {
                            WorkspaceService.focus({workspace: Math.max(1, wsDelegate.wsId - 1)})
                        }
                    }
                    
                    // Hover effect
                    states: State {
                        name: "hovered"
                        when: parent.containsMouse && !wsDelegate.isActive
                        PropertyChanges {
                            target: wsDelegate.background
                            color: Qt.rgba(Catppuccin.blue.r, Catppuccin.blue.g, Catppuccin.blue.b, 0.3)
                        }
                    }
                }
            }
        }
    }
}
