import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import QtQuick
import QtQuick.Layouts

import "modules"
import "components"

PanelWindow {
    property int paddingHeight: 100
    property int paddingWidth: 100
    property int trayHeight: 50

    id: main
    color: "transparent"
    aboveWindows: true
    implicitHeight: Screen.height - paddingHeight
    implicitWidth: Screen.width - paddingWidth

    WlrLayershell.keyboardFocus: WlrKeyboardFocus.Exclusive

    KeyBinds {}

    // Top Bar
    Rectangle {
        id: topBar
        width: parent.width - 20
        height: main.trayHeight
        color: colors.color5
        anchors {
            top: parent.top
            horizontalCenter: parent.horizontalCenter
        }
        DateTime{}
        Launcher{}
        Tray{}
    }

    // Main
    GridLayout {
        id: grid
        columns: 3
        rows: 2
        columnSpacing: 12
        rowSpacing: 12

        anchors {
            top: topBar.bottom
            bottom: parent.bottom
            left: parent.left
            right: parent.right
            topMargin: 16 // Spacing from top edge
        }

        // Setting preferred dimensions to 1 forces the layout to weigh all cells equally
        CalendarComp   { Layout.fillWidth: true; Layout.fillHeight: true; Layout.preferredWidth: 1; Layout.preferredHeight: 1 }
        Workspaces     { Layout.fillWidth: true; Layout.fillHeight: true; Layout.preferredWidth: 1; Layout.preferredHeight: 1 }
        Todos          { Layout.fillWidth: true; Layout.fillHeight: true; Layout.preferredWidth: 1; Layout.preferredHeight: 1 }
        Notifications  { Layout.fillWidth: true; Layout.fillHeight: true; Layout.preferredWidth: 1; Layout.preferredHeight: 1 }
        SpWorkspaces   { Layout.fillWidth: true; Layout.fillHeight: true; Layout.preferredWidth: 1; Layout.preferredHeight: 1 }
        Calculator     { Layout.fillWidth: true; Layout.fillHeight: true; Layout.preferredWidth: 1; Layout.preferredHeight: 1 }
    }

    FileView {
        path: Quickshell.shellPath("colors.json")
        watchChanges: true
        onFileChanged: reload()

        JsonAdapter {
            id: colors
            property string background
            property string foreground
            property string cursor
            property string color0
            property string color1
            property string color2
            property string color3
            property string color4
            property string color5
            property string color6
            property string color7
            property string color8
            property string color9
            property string color10
            property string color11
            property string color12
            property string color13
            property string color14
            property string color15
        }

    }
}
