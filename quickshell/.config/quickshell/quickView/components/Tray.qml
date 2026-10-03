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
            Layout.preferredWidth: 36
            Layout.preferredHeight: 36

            radius: 10
            color: mouseArea.pressed ? theme.fade(colors.foreground, 0.18)
                 : mouseArea.containsMouse ? theme.fade(colors.foreground, 0.10)
                 : "transparent"
            border.width: 1
            border.color: mouseArea.containsMouse ? theme.line : "transparent"

            Behavior on color {
                ColorAnimation {
                    duration: 120
                }
            }

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
                width: 22
                height: 22
                source: modelData.icon
                opacity: mouseArea.containsMouse ? 1.0 : 0.85

                Behavior on opacity {
                    NumberAnimation {
                        duration: 120
                    }
                }
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
