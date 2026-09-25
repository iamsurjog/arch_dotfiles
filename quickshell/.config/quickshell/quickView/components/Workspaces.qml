import QtQuick
import QtQuick.Layouts
import Quickshell.Hyprland

Item {
    id: root

    // Dynamically find the currently focused workspace ID in Hyprland
    property int currentActiveId: {
        let activeWorkspaces = Array.from(Hyprland.workspaces.values);
        let focusedWs = activeWorkspaces.find(ws => ws.focused);
        return focusedWs ? focusedWs.id : 1;
    }

    // Your floor division formula: wkspId // 10 * 10 + 1
    property int startingId: Math.floor(currentActiveId / 10) * 10 + 1

    GridLayout {
        anchors.fill: parent
        columns: 3
        columnSpacing: 10
        rowSpacing: 10

        Repeater {
            model: 9 

            Rectangle {
                // Add the index (0-8) to the starting ID
                property int wsId: root.startingId + index
                
                property var wsData: {
                    let activeWorkspaces = Array.from(Hyprland.workspaces.values);
                    return activeWorkspaces.find(ws => ws.id === wsId);
                }
                
                property bool isActive: wsData ? wsData.active : false
                property bool isOccupied: !!wsData

                Layout.fillWidth: true
                Layout.fillHeight: true
                
                color: colors.background
                
                border.width: isActive ? 2 : 0
                border.color: colors.color5 
                
                // radius: 6 

                Text {
                    anchors.centerIn: parent
                    text: wsId
                    
                    color: isOccupied ? colors.foreground : colors.color8 
                    
                    font.pixelSize: 20
                    font.bold: true
                }
            }
        }
    }
}
