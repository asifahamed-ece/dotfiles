pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Services.Mpris

QtObject {
    id: root
    
    property var player: MprisService.player
    readonly property bool hasPlayer: player !== null && player !== undefined
    readonly property bool isPlaying: hasPlayer && player.playbackStatus === MprisPlaybackStatus.Playing
    readonly property string trackTitle: hasPlayer ? (player.trackInfo.title || "Unknown Track") : ""
    readonly property string trackArtist: hasPlayer ? (player.trackInfo.artist || "Unknown Artist") : ""
    readonly property string albumArt: hasPlayer && player.trackInfo.artUrl ? player.trackInfo.artUrl : ""
    
    // FrameAnimation trick: only consume CPU when actively playing
    // When paused/stopped, the animation stops and QML becomes static
    FrameAnimation {
        id: playStateWatcher
        running: isPlaying
        interval: 1000 // Check every second when playing
    }
    
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
