import QtQuick
import Quickshell.Controls as QsControls
import Quickshell.Services.Mpris

import "../theme"

QsControls.Surface {
    id: mediaPlayer
    
    // Only render when there's an active player - event-driven visibility
    visible: mediaService.hasPlayer
    
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
        
        onClicked: mediaService.togglePlayPause()
        onWheel: wheel => {
            if (wheel.angleDelta.y > 0) {
                mediaService.next()
            } else {
                mediaService.previous()
            }
        }
    }
    
    RowLayout {
        id: mediaRow
        anchors.centerIn: parent
        spacing: 12
        
        // Play/Pause Button
        Text {
            id: playPauseIcon
            text: mediaService.isPlaying ? "" : ""
            color: mediaService.isPlaying ? Catppuccin.green : Catppuccin.text
            font.family: "Font Awesome 6 Free Solid"
            font.pixelSize: 16
            
            Behavior on color {
                ColorAnimation { duration: Catppuccin.transitionFast }
            }
            
            // FrameAnimation-driven opacity pulse when playing
            opacity: mediaService.isPlaying ? 1.0 : 0.7
            FrameAnimation {
                running: mediaService.isPlaying
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
                text: mediaService.trackTitle
                color: Catppuccin.text
                font.family: "JetBrainsMono Nerd Font Propo"
                font.pixelSize: 11
                font.weight: Font.Bold
                elide: Text.ElideRight
                visible: mediaService.trackTitle.length > 0
            }
            
            Text {
                text: mediaService.trackArtist
                color: Catppuccin.subtext0
                font.family: "JetBrainsMono Nerd Font Propo"
                font.pixelSize: 9
                elide: Text.ElideRight
                visible: mediaService.trackArtist.length > 0
            }
        }
    }
    
    // Media Service wrapper using Quickshell's Mpris bindings
    QtObject {
        id: mediaService
        
        property var player: MprisService.player
        readonly property bool hasPlayer: player !== null && player !== undefined
        readonly property bool isPlaying: hasPlayer && player.playbackStatus === MprisPlaybackStatus.Playing
        readonly property string trackTitle: hasPlayer ? (player.trackInfo.title || "Unknown Track") : ""
        readonly property string trackArtist: hasPlayer ? (player.trackInfo.artist || "Unknown Artist") : ""
        
        function togglePlayPause() {
            if (hasPlayer) {
                player.togglePlaying()
            }
        }
        
        function next() {
            if (hasPlayer) {
                player.next()
            }
        }
        
        function previous() {
            if (hasPlayer) {
                player.previous()
            }
        }
    }
}
