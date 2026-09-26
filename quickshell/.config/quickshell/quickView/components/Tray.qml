import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Services.SystemTray
import Quickshell.Widgets

RowLayout {
    id: root
    spacing: 8

    // Explicitly require the root window reference from shell.qml
    property var panelRoot

    Repeater {
        model: SystemTray.items

        delegate: Rectangle {
            id: trayItemRec
            Layout.preferredWidth: 35
            Layout.preferredHeight: 35
            
            color: mouseArea.containsMouse ? (typeof colors !== "undefined" ? colors.color0 : "#313244") : "transparent"
            radius: 6

            QsMenuAnchor {
                id: menuAnchor
                menu: modelData.menu
                
                anchor {
                    // Use the hard reference instead of the dynamic attached property
                    window: root.panelRoot
                    
                    rect.x: trayItemRec.mapToItem(root.panelRoot, 0, 0).x
                    rect.y: trayItemRec.mapToItem(root.panelRoot, 0, 0).y
                    rect.width: trayItemRec.width
                    rect.height: trayItemRec.height
                    
                    edges: Edges.Bottom | Edges.Left
                }
            }

            IconImage {
                anchors.centerIn: parent
                width: 23
                height: 23
                source: modelData.icon
            }

            MouseArea {
                id: mouseArea
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                
                acceptedButtons: Qt.LeftButton | Qt.RightButton | Qt.MiddleButton
                
                onClicked: (mouse) => {
                    if (mouse.button === Qt.LeftButton) {
                        modelData.activate() 
                    } 
                    else if (mouse.button === Qt.RightButton) {
                        if (menuAnchor.menu) {
                            menuAnchor.anchor.updateAnchor()
                            menuAnchor.open()
                        }
                    } 
                    else if (mouse.button === Qt.MiddleButton) {
                        modelData.secondaryActivate() 
                    }
                }
                
                onWheel: (wheel) => {
                    let delta = wheel.angleDelta.y
                    if (delta !== 0) {
                        modelData.scroll(delta, false)
                    }
                }
            }
        }
    }
}
