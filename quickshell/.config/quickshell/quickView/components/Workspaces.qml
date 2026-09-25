import QtQuick
import QtQuick.Layouts
import Quickshell.Hyprland

Rectangle {
    width: main.trayHeight
    height: main.trayHeight
    color: colors.background

    property int activeWsId: Hyprland.activeWorkspace ? Hyprland.activeWorkspace.id : 1
    property int pageBase: Math.floor(Math.max(0, activeWsId - 1) / 10) * 10

    GridLayout {
        anchors.fill: parent
        anchors.margins: 4
        columns: 3
        rows: 3
        columnSpacing: 4
        rowSpacing: 4

        Repeater {
            model: 9
            
            delegate: Rectangle {
                property int workspaceId: pageBase + index + 1
                property bool isActive: activeWsId === workspaceId

                Layout.fillWidth: true
                Layout.fillHeight: true
                
                color: isActive ? colors.color5 : colors.color9
                border.color: colors.color7
                border.width: 1
                radius: 4

                // Faded workspace number in the background
                Text {
                    anchors.centerIn: parent
                    text: workspaceId
                    color: colors.background
                    font.pixelSize: 32
                    opacity: 0.3
                    font.bold: true
                }

                // Active Windows Grid
                Flow {
                    anchors.fill: parent
                    anchors.margins: 4
                    spacing: 4

                    Repeater {
                        model: Hyprland.toplevels.values
                        
                        delegate: Rectangle {
                            required property var modelData

                            // Only render if the window belongs to this specific workspace
                            property bool isHere: modelData.workspace && modelData.workspace.id === workspaceId
                            
                            visible: isHere
                            width: isHere ? 24 : 0
                            height: isHere ? 24 : 0
                            
                            // Highlight the currently focused window
                            color: modelData.activated ? colors.color1 : colors.color3
                            radius: 4

                            Text {
                                anchors.centerIn: parent
                                // Show the first letter of the window title
                                text: modelData.title ? modelData.title.charAt(0).toUpperCase() : "?"
                                color: colors.foreground
                                font.bold: true
                            }
                        }
                    }
                }

                MouseArea {
                    anchors.fill: parent
                    // Fix: Concatenated string for the dispatcher
                    onClicked: Hyprland.dispatch("workspace " + workspaceId)
                }

                DropArea {
                    anchors.fill: parent
                    keys: ["hyprland-client"] 
                    
                    onDropped: (drop) => {
                        if (drop.hasText) {
                            // Fix: Concatenated string here as well
                            Hyprland.dispatch("movetoworkspacesilent " + workspaceId + ",address:" + drop.text)
                            drop.accept()
                        }
                    }
                }
            }
        }
    }
}
