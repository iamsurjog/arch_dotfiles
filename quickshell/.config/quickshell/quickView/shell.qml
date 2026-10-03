//@ pragma UseQApplication
import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import QtQuick
import QtQuick.Layouts

import "modules/menus"
import "modules"
import "components"

PanelWindow {
    property int paddingHeight: 100
    property int paddingWidth: 100
    property int trayHeight: 50
    property int barHeight: 68
    property bool isOpen: false

    visible: isOpen

    id: main
    color: "transparent"
    aboveWindows: true
    implicitHeight: Screen.height - paddingHeight
    implicitWidth: Screen.width - paddingWidth

    WlrLayershell.keyboardFocus: WlrKeyboardFocus.Exclusive

    onIsOpenChanged: {
        if (isOpen) {
            Qt.callLater(() => {
                if (main.isOpen)
                    launcher.activate()
            })
        } else {
            launcher.resetInput()
        }
    }

    // ------------------------------------------------------------------
    // Theme. Every value here is derived from colors.json through the
    // `colors` adapter below, so the whole shell follows one palette.
    // ------------------------------------------------------------------
    QtObject {
        id: theme

        // "#RRGGBB" / "#AARRGGBB" -> [r, g, b] (0-255), or null
        function rgb(c) {
            var s = String(c === undefined || c === null ? "" : c).replace("#", "")
            if (s.length === 3) s = s[0] + s[0] + s[1] + s[1] + s[2] + s[2]
            if (s.length >= 8) s = s.substr(2, 6)
            if (s.length !== 6) return null
            var r = parseInt(s.substr(0, 2), 16)
            var g = parseInt(s.substr(2, 2), 16)
            var b = parseInt(s.substr(4, 2), 16)
            if (isNaN(r) || isNaN(g) || isNaN(b)) return null
            return [r, g, b]
        }

        // A palette colour with an opacity applied to it
        function fade(c, opacity) {
            var v = rgb(c)
            var a = Math.max(0, Math.min(1, opacity))
            if (!v) return Qt.rgba(0, 0, 0, 0)
            return Qt.rgba(v[0] / 255, v[1] / 255, v[2] / 255, a)
        }

        // Two palette colours blended together, optionally with an opacity
        function mix(a, b, t, opacity) {
            var x = rgb(a)
            var y = rgb(b)
            var o = opacity === undefined ? 1 : Math.max(0, Math.min(1, opacity))
            if (!x || !y) return fade(a, o)
            return Qt.rgba((x[0] + (y[0] - x[0]) * t) / 255, (x[1] + (y[1] - x[1]) * t) / 255, (x[2] + (y[2] - x[2]) * t) / 255, o)
        }

        // --- surfaces -------------------------------------------------
        readonly property color sheet: fade(colors.background, 0.52) // dims the desktop behind everything
        readonly property color bar: fade(colors.background, 0.82) // top bar plate
        readonly property color card: fade(colors.background, 0.84) // grid cards
        readonly property color cardDeep: fade(colors.background, 0.68) // bottom of a card gradient
        readonly property color field: fade(colors.color0, 0.55) // inputs & wells
        readonly property color raised: fade(colors.foreground, 0.06) // tiles, rows, hovers

        // --- lines & accents -----------------------------------------
        readonly property color line: fade(colors.foreground, 0.10)
        readonly property color lineSoft: fade(colors.foreground, 0.06)
        readonly property color accent: colors.color10
        readonly property color accentSoft: fade(colors.color10, 0.28)
        readonly property color ring: fade(colors.cursor, 0.85)

        // --- text -----------------------------------------------------
        readonly property color text: colors.foreground
        readonly property color textDim: colors.color8
        readonly property color textMute: fade(colors.color8, 0.55)
    }

    // Dimmed, rounded sheet: rounds off the whole overlay and lets the
    // wallpaper bleed through so the cards can float on top of it.
    Rectangle {
        id: backdrop
        anchors.fill: parent
        radius: 26
        color: "transparent"
        gradient: Gradient {
            GradientStop {
                position: 0.0
                color: theme.fade(colors.background, 0.66)
            }
            GradientStop {
                position: 1.0
                color: theme.fade(colors.background, 0.44)
            }
        }
        border.width: 1
        border.color: theme.lineSoft
    }

    KeyBinds {
        panelRoot: main
    }

    IpcHandler {
        target: "quickView"

        function show(): void {
            if (main.isOpen)
                launcher.activate()
            else
                main.isOpen = true
        }

        function hide(): void {
            main.isOpen = false
        }

        function toggle(): void {
            main.isOpen = !main.isOpen
        }
    }

    // Plate sitting behind the top bar
    Rectangle {
        id: topBarBg
        anchors.fill: topBar
        radius: 18
        color: "transparent"
        gradient: Gradient {
            GradientStop {
                position: 0.0
                color: theme.fade(colors.background, 0.88)
            }
            GradientStop {
                position: 1.0
                color: theme.fade(colors.background, 0.74)
            }
        }
        border.width: 1
        border.color: theme.line
    }

    // Top Bar
    Item {
        id: topBar
        height: main.barHeight

        anchors {
            top: parent.top
            left: parent.left
            right: parent.right
            topMargin: 14
            leftMargin: 16
            rightMargin: 16
        }

        Tray {
            panelRoot: main

            anchors {
                left: parent.left
                top: parent.top
                bottom: parent.bottom
                leftMargin: 8
            }
        }
        // 1. Your left-side items go here (e.g., a clock, a logo, or window title)
        Launcher {
            id: launcher

            anchors {
                horizontalCenter: parent.horizontalCenter
                top: parent.top
                bottom: parent.bottom
                topMargin: 9
                bottomMargin: 9
            }
        }

        // 2. The magical expanding spacer. This eats all available empty space
        // in the middle of the screen, forcing everything after it to the right.
        DateTime {
            anchors {
                right: parent.right
                top: parent.top
                bottom: parent.bottom
                rightMargin: 8
            }
        }

        // 3. Your Tray, perfectly pushed to the right side
    }

    // Main
    GridLayout {
        id: grid
        columns: 3
        rows: 2
        columnSpacing: 14
        rowSpacing: 14
        visible: !launcher.typing

        anchors {
            top: topBar.bottom
            bottom: parent.bottom
            left: parent.left
            right: parent.right
            topMargin: 14 // Spacing from top edge
            leftMargin: 16
            rightMargin: 16
            bottomMargin: 16
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
