import QtQuick 
import QtQuick.Controls 
import Quickshell 
import Quickshell.Wayland
import Quickshell.Hyprland
import Quickshell.Widgets
import Quickshell.Io
import QtCore

import "src"

FreezeScreen {
    id: root
    visible: false

    property var activeScreen: null

    Settings {
        id: settings
        category: "Hyprquickshot"
        property bool saveToDisk: false 
    }

    Connections {
        target: Hyprland
        enabled: activeScreen === null

        function onFocusedMonitorChanged() {
            const monitor = Hyprland.focusedMonitor
            if(!monitor) return

            for (const screen of Quickshell.screens) {
                if (screen.name === monitor.name) {
                    activeScreen = screen

                    const timestamp = Date.now()
                    const path = Quickshell.cachePath(`screenshot-${timestamp}.png`)
                    tempPath = path
                    Quickshell.execDetached(["grim", "-g", `${screen.x},${screen.y} ${screen.width}x${screen.height}`, path])
                    showTimer.start()
                }
            }
        }
    }

    targetScreen: activeScreen

    property var hyprlandMonitor: Hyprland.focusedMonitor
    property string tempPath

    property string mode: "region"

    Shortcut {
        sequence: "Escape"
        onActivated: () => {
            Quickshell.execDetached(["rm", tempPath])
            Qt.quit()
        }
    }
 
    Timer {
        id: showTimer
        interval: 50
        running: false
        repeat: false
        onTriggered: root.visible = true
    }
 
    Process {
        id: screenshotProcess
        running: false

        onExited: () => {
            Qt.quit()
        }

        stdout: StdioCollector {
            onStreamFinished: console.log(this.text)
        }
        stderr: StdioCollector {
            onStreamFinished: console.log(this.text)
        }

    }

    function processScreenshot(x, y, width, height) {
        const scale = hyprlandMonitor.scale
        const scaledX = Math.round(x * scale)
        const scaledY = Math.round(y * scale)
        const scaledWidth = Math.round(width * scale)
        const scaledHeight = Math.round(height * scale)

        const picturesDir = Quickshell.env("HQS_DIR") || Quickshell.env("XDG_SCREENSHOTS_DIR") || Quickshell.env("XDG_PICTURES_DIR") || (Quickshell.env("HOME") + "/Pictures")

        const now = new Date()
        const timestamp = Qt.formatDateTime(now, "yyyy-MM-dd_hh-mm-ss")

        const outputPath = settings.saveToDisk ? `${picturesDir}/screenshot-${timestamp}.png` : root.tempPath

        screenshotProcess.command = ["sh", "-c",
            `magick "${tempPath}" -crop ${scaledWidth}x${scaledHeight}+${scaledX}+${scaledY} "${outputPath}" && ` +
            `tesseract "${outputPath}" - -l eng | wl-copy &&`+ 
            `rm "${tempPath}"`
        ]
        Quickshell.execDetached(["notify-send", "-i", "clipboard", "-a", "Hyprquicksnip", "OCR Taken", "Copied to Clipboard"])

        screenshotProcess.running = true
        root.visible = false
    }

    RegionSelector {
        visible: mode === "region"
        id: regionSelector
        anchors.fill: parent
 
        dimOpacity: 0.6
        borderRadius: 10.0
        outlineThickness: 2.0
 
        onRegionSelected: (x, y, width, height) => {
            processScreenshot(x, y, width, height)
        }
    }
 
    WindowSelector {
        visible: mode === "window"
        id: windowSelector
        anchors.fill: parent
 
        monitor: root.hyprlandMonitor
        dimOpacity: 0.6
        borderRadius: 10.0
        outlineThickness: 2.0
 
        onRegionSelected: (x, y, width, height) => {
            processScreenshot(x, y, width, height)
        }
    }
 
    WrapperRectangle {
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 40

        color: Qt.rgba(0.1, 0.1, 0.1, 0.8)
        radius: 12
        margin: 8


    }
}
