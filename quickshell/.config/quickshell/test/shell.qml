import Quickshell
import Quickshell.Io // for Process
import QtQuick

PanelWindow {
    id: mainWindow
    property bool hovering: false
    anchors {
        right: true
    }
    margins{
        right: hovering? -2:-this.width + 2
    }

    implicitHeight: Screen.desktopAvailableHeight - 60
    aboveWindows: true
    exclusiveZone: 1
    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        onEntered: {
            hovering = true
        }
        onExited: {
            hovering = false
        }
    }
}

