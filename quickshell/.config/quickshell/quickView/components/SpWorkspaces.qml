import QtQuick
import QtQuick.Layouts
import Quickshell.Hyprland
import Quickshell.Wayland

Item {
    id: root

    property var specialWorkspaces: {
        return Array.from(Hyprland.workspaces.values)
            .filter(ws => ws.id < 0)
            .slice(0, 4)
    }

    GridLayout {
        anchors.fill: parent
        columns: 2
        rows: 2
        columnSpacing: 10
        rowSpacing: 10

        Repeater {
            model: 4 // Force exactly 4 boxes

            Rectangle {
                // Safely grab the workspace data if it exists at this index
                property var wsData: index < root.specialWorkspaces.length ? root.specialWorkspaces[index] : null
                property bool isOccupied: !!wsData
                
                property int wsId: isOccupied ? wsData.id : 0
                property string wsName: isOccupied ? wsData.name.replace("special:", "") : ""

                property var workspaceClients: {
                    if (!isOccupied) return []
                    let allWindows = Array.from(Hyprland.toplevels.values);
                    return allWindows.filter(client => client.workspace && client.workspace.id === wsId);
                }

                Layout.fillWidth: true
                Layout.fillHeight: true

                color: typeof colors !== "undefined" ? colors.background : "#1e1e2e"
                
                border.width: (isOccupied && wsData.active) ? 2 : 0
                border.color: typeof colors !== "undefined" ? colors.color5 : "#89b4fa"
                clip: true
                radius: 6

                // Background text (hidden if empty)
                Text {
                    anchors.centerIn: parent
                    text: wsName
                    color: typeof colors !== "undefined" ? colors.foreground : "#cdd6f4"
                    opacity: 0.05
                    font.pixelSize: 40
                    font.bold: true
                    visible: isOccupied
                }

                // Grid of live window previews
                GridLayout {
                    anchors.fill: parent
                    anchors.margins: 12

                    columns: workspaceClients.length > 2 ? 2 : 1
                    rowSpacing: 8
                    columnSpacing: 8

                    Repeater {
                        model: workspaceClients

                        ScreencopyView {
                            Layout.fillWidth: true
                            Layout.fillHeight: true

                            captureSource: modelData.wayland
                            live: true
                        }
                    }
                }

                // Small indicator overlaid at the bottom right (hidden if empty)
                Text {
                    anchors {
                        bottom: parent.bottom
                        right: parent.right
                        margins: 6
                    }
                    text: wsName
                    color: typeof colors !== "undefined" ? colors.foreground : "#cdd6f4"
                    font.pixelSize: 14
                    font.bold: true
                    visible: isOccupied
                }
            }
        }
    }
}
