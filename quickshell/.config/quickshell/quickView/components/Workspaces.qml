import QtQuick
import QtQuick.Layouts
import Quickshell.Hyprland
import Quickshell.Wayland // Required for ScreencopyView

Rectangle {
    id: root

    radius: 16
    clip: true
    color: "transparent"
    gradient: Gradient {
        GradientStop {
            position: 0.0
            color: theme.card
        }
        GradientStop {
            position: 1.0
            color: theme.cardDeep
        }
    }
    border.width: 1
    border.color: theme.line

    property int currentActiveId: {
        let activeWorkspaces = Array.from(Hyprland.workspaces.values);
        let focusedWs = activeWorkspaces.find(ws => ws.focused);
        return focusedWs ? focusedWs.id : 1;
    }

    property int startingId: Math.floor(currentActiveId / 10) * 10 + 1

    GridLayout {
        anchors.fill: parent
        anchors.margins: 12
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
                
                // Empty slots read as faint wells, occupied ones get a lift,
                // the focused one wears the accent
                color: isActive ? theme.fade(colors.color10, 0.26)
                     : isOccupied ? theme.fade(colors.foreground, 0.07)
                     : theme.fade(colors.foreground, 0.035)
                border.width: isActive ? 2 : 1
                border.color: isActive ? theme.ring : theme.lineSoft
                clip: true 
                radius: 12

                Behavior on color {
                    ColorAnimation {
                        duration: 160
                    }
                }
                Behavior on border.color {
                    ColorAnimation {
                        duration: 160
                    }
                }

                // Background ID text
                Text {
                    anchors.centerIn: parent
                    text: wsId
                    color: theme.text
                    opacity: 0.06
                    font.pixelSize: 56
                    font.bold: true
                }

                // Grid of live window previews
                GridLayout {
                    anchors.fill: parent
                    anchors.margins: 10
                    
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
