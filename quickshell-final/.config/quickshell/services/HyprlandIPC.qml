import QtQuick
import Quickshell.Services.Hyprland

pragma Singleton

QtObject {
    id: hyprlandIPC
    
    // Event-driven Hyprland IPC service
    // Quickshell's Hyprland service listens to the Hyprland socket automatically
    // No polling required - all updates are push-based via IPC events
    
    readonly property var workspaces: Hyprland.workspaces
    readonly property var activeWorkspace: Hyprland.activeWorkspace
    readonly property var clients: Hyprland.clients
    
    // Focus a workspace by ID
    function focusWorkspace(id: int) {
        Hyprland.focus({workspace: id})
    }
    
    // Move current window to workspace
    function moveWindowToWorkspace(id: int) {
        Hyprland.windowMove({workspace: id})
    }
    
    // Toggle special workspace (scratchpad)
    function toggleSpecialWorkspace(name: string = "magic") {
        Hyprland.toggleSpecial(name)
    }
    
    // Get workspace by ID
    function getWorkspaceById(id: int) {
        for (var i = 0; i < workspaces.length; i++) {
            if (workspaces[i].id === id) {
                return workspaces[i]
            }
        }
        return null
    }
    
    // Count windows in a workspace
    function windowCountInWorkspace(wsId: int): int {
        var count = 0
        for (var i = 0; i < clients.length; i++) {
            if (clients[i].workspace.id === wsId) {
                count++
            }
        }
        return count
    }
}
