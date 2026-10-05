import QtQuick
import QtQuick.Layouts
import Quickshell.Hyprland
import Quickshell.Wayland

Rectangle {
    id: spwkspc

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

    property var specialWorkspaces: {
        return Array.from(Hyprland.workspaces.values)
            .filter(ws => ws.id < 0)
            .slice(0, 4)
    }

    GridLayout {
        anchors.fill: parent
        anchors.margins: 12
        columns: 2
        rows: 2
        columnSpacing: 10
        rowSpacing: 10

        Repeater {
            model: 4 // Force exactly 4 boxes

            Rectangle {
                // Safely grab the workspace data if it exists at this index
                property var wsData: index < spwkspc.specialWorkspaces.length ? spwkspc.specialWorkspaces[index] : null
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

                color: (isOccupied && wsData.active) ? theme.fade(colors.color10, 0.26)
                     : isOccupied ? theme.fade(colors.foreground, 0.07)
                     : theme.fade(colors.foreground, 0.035)

                border.width: (isOccupied && wsData.active) ? 2 : 1
                border.color: (isOccupied && wsData.active) ? theme.ring : theme.lineSoft
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

                // Background text (hidden if empty)
                Text {
                    anchors.centerIn: parent
                    text: wsName
                    color: theme.text
                    opacity: 0.06
                    font.pixelSize: 36
                    font.bold: true
                    visible: isOccupied
                }

                // Grid of live window previews
                GridLayout {
                    anchors.fill: parent
                    anchors.margins: 10

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

                // Small chip in the corner so the name stays readable
                // over whatever the preview is showing
                Rectangle {
                    id: nameChip
                    anchors {
                        bottom: parent.bottom
                        right: parent.right
                        margins: 8
                    }
                    width: nameLabel.width + 16
                    height: nameLabel.height + 8
                    radius: 7
                    color: theme.fade(colors.background, 0.80)
                    border.width: 1
                    border.color: theme.line
                    visible: isOccupied && wsName !== ""

                    Text {
                        id: nameLabel
                        anchors.centerIn: parent
                        text: wsName
                        color: theme.text
                        font.pixelSize: 13
                        font.bold: true
                    }
                }
            }
        }
    }
}
