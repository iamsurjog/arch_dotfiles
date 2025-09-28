import Quickshell
import QtQuick
import QtQuick.Controls

Scope {
    id: root

    Variants {
        model: Quickshell.screens
        PanelWindow {
            required property var modelData
            screen: modelData
            anchors {
                top: true
                left: true
                right: true
            }
            implicitHeight: 40

            LeftPopout {
                anchors.left: parent.left
            }

            RightControls {
                anchors.right: parent.right
            }
        }
    }
}

