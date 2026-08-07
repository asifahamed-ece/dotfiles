import QtQuick
import Quickshell
import Quickshell.Controls as QsControls
import Quickshell.Services.Hyprland

import "../theme"

QtObject {
    id: workspaceService
    
    // Hyprland IPC is event-driven by default - no polling needed!
    // WorkspaceService listens to Hyprland's socket events
    readonly property var workspaces: WorkspaceService.workspaces
    readonly property var activeWorkspace: WorkspaceService.activeWorkspace
    
    // Get workspace by ID for activation
    function activate(id: int) {
        WorkspaceService.focus({workspace: id})
    }
    
    // Move window to workspace
    function moveWindowTo(workspaceId: int) {
        WorkspaceService.windowMove({workspace: workspaceId})
    }
    
    // Toggle special workspace (scratchpad)
    function toggleSpecial(name: string = "magic") {
        WorkspaceService.toggleSpecial(name)
    }
}
