import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Controls as QsControls
import Quickshell.Services.Mpris

import "../theme"
import "../services"

QsControls.Surface {
    id: mediaPlayer
    
    // Only render when there's an active player - event-driven visibility
    visible: MediaService.hasPlayer
    
    implicitHeight: Catppuccin.barHeight + 8
    implicitWidth: mediaRow.implicitWidth + 24
    
    // Glass module styling matching Waybar
    background: Rectangle {
        color: Catppuccin.moduleBg
        border.color: Catppuccin.glassBorder
        border.width: 1
        radius: Catppuccin.moduleRadius
        
        Behavior on color {
            ColorAnimation { duration: Catppuccin.transitionSlow }
        }
        
        // Hover effect
        states: State {
            name: "hovered"
            when: mouseArea.containsMouse
            PropertyChanges { target: background; color: Catppuccin.moduleBgHover }
            PropertyChanges { target: background; border.color: Catppuccin.blue }
        }
    }
    
    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        
        onClicked: MediaService.togglePlayPause()
        onWheel: wheel => {
            if (wheel.angleDelta.y > 0) {
                MediaService.next()
            } else {
                MediaService.previous()
            }
        }
    }
    
    RowLayout {
        id: mediaRow
        anchors.centerIn: parent
        spacing: 12
        
        // Play/Pause Button
        QsControls.Icons.FontAwesome {
            id: playPauseIcon
            implicitSize: 16
            color: isPlaying ? Catppuccin.green : Catppuccin.text
            icon: isPlaying ? FontAwesomeIcon.pause : FontAwesomeIcon.play
            
            Behavior on color {
                ColorAnimation { duration: Catppuccin.transitionFast }
            }
            
            // FrameAnimation-driven opacity pulse when playing
            opacity: isPlaying ? 1.0 : 0.7
            FrameAnimation {
                running: isPlaying
                interval: 500
                onTriggered: {
                    playPauseIcon.opacity = (playPauseIcon.opacity === 1.0) ? 0.85 : 1.0
                }
            }
        }
        
        // Track Info - only updates when metadata changes (event-driven)
        ColumnLayout {
            Layout.maximumWidth: 200
            spacing: 0
            
            Text {
                text: MediaService.trackTitle
                color: Catppuccin.text
                font.family: "JetBrainsMono Nerd Font Propo"
                font.pixelSize: 11
                font.weight: Font.Bold
                elide: Text.ElideRight
                visible: MediaService.trackTitle.length > 0
            }
            
            Text {
                text: MediaService.trackArtist
                color: Catppuccin.subtext0
                font.family: "JetBrainsMono Nerd Font Propo"
                font.pixelSize: 9
                elide: Text.ElideRight
                visible: MediaService.trackArtist.length > 0
            }
        }
    }
}
