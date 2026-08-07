import QtQuick
import Quickshell

pragma Singleton

QtObject {
    id: root
    
    // Main entry point for Quickshell configuration
    // This file is loaded automatically by quickshell
    
    // Import theme singleton
    property var theme: Catppuccin
    
    // ShellRoot provides the main surface container
    ShellRoot {
        anchors.fill: parent
        
        // Main top bar
        Bar {
            id: topBar
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right
        }
        
        // Media player overlay - only visible when media is playing
        MediaPlayer {
            anchors.bottom: topBar.top
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottomMargin: 8
        }
    }
}
