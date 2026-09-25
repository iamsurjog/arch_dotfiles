import QtQuick
import QtQuick.Layouts
import Quickshell.Hyprland
import Quickshell.Wayland // Required for ScreencopyView

Item {
    id: root

    property int currentActiveId: {
        let activeWorkspaces = Array.from(Hyprland.workspaces.values);
        let focusedWs = activeWorkspaces.find(ws => ws.focused);
        return focusedWs ? focusedWs.id : 1;
    }

    property int startingId: Math.floor(currentActiveId / 10) * 10 + 1

    GridLayout {
        anchors.fill: parent
        columns: 3
        columnSpacing: 10
        rowSpacing: 10

        Repeater {
            model: 9 

            Rectangle {
                property int wsId: root.startingId + index
                
                property var wsData: {
                    let activeWorkspaces = Array.from(Hyprland.workspaces.values);
                    return activeWorkspaces.find(ws => ws.id === wsId);
                }
                
                property var workspaceClients: {
                    let allWindows = Array.from(Hyprland.toplevels.values);
                    return allWindows.filter(client => client.workspace && client.workspace.id === wsId);
                }
                
                property bool isActive: wsData ? wsData.active : false
                property bool isOccupied: !!wsData || workspaceClients.length > 0

                Layout.fillWidth: true
                Layout.fillHeight: true
                
                color: colors.background
                border.width: isActive ? 2 : 0
                border.color: colors.color5 
                clip: true 
                radius: 6 

                // Background ID text
                Text {
                    anchors.centerIn: parent
                    text: wsId
                    color: colors.foreground
                    opacity: 0.05
                    font.pixelSize: 60
                    font.bold: true
                }

                // Grid of live window previews
                GridLayout {
                    anchors.fill: parent
                    anchors.margins: 12
                    
                    // Auto-adjust layout so 1 window takes the whole box, 
                    // 2 windows split it, 3+ form a grid.
                    columns: workspaceClients.length > 2 ? 2 : 1
                    rowSpacing: 8
                    columnSpacing: 8
                    
                    Repeater {
                        model: workspaceClients
                        
                        ScreencopyView {
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                            
                            // Extract the Wayland Toplevel handle from the wrapper
                            captureSource: modelData.wayland
                            
                            live: true 
                        }
                    }
                }
                
            }
        }
    }
}
