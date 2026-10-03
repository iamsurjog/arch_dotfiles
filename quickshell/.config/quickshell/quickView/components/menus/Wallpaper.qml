import Quickshell
import Quickshell.Io
import QtQuick
import Qt.labs.folderlistmodel

Item {
    id: wallRoot
    implicitHeight: 500

    property int speed: 5000

    // --- GLOBAL SHORTCUTS THAT BYPASS FOCUS ---
    // The "enabled: wallRoot.visible" ensures they only trigger when the wall menu is open
    // --- ROLLBACK LOGIC ---
    property bool wallpaperSelected: false

    onVisibleChanged: {
        if (visible) {
            // Reset state when the menu opens
            wallpaperSelected = false
        } else if (!wallpaperSelected) {
            // If the menu closed (Escape, Windows key, etc.) without selecting, revert colors
            Quickshell.execDetached(["wallust", "run", "/home/randomguy/Pictures/wallpaper.png"])
        }
    }

    Shortcut {
        sequence: "Ctrl+J"
        enabled: wallRoot.visible
        onActivated: {
            list.animSpeed = wallRoot.speed
            list.selectedIndex = list.clampIndex(list.selectedIndex + 1)
            list.ensureVisibleAnimated(list.selectedIndex)
        }
    }
    Shortcut {
        sequence: "Ctrl+K"
        enabled: wallRoot.visible
        onActivated: {
            list.animSpeed = wallRoot.speed
            list.selectedIndex = list.clampIndex(list.selectedIndex - 1)
            list.ensureVisibleAnimated(list.selectedIndex)
        }
    }
    Shortcut {
        sequence: "Ctrl+D"
        enabled: wallRoot.visible
        onActivated: {
            list.animSpeed = wallRoot.speed * 7
            list.selectedIndex = list.clampIndex(list.selectedIndex + 7)
            list.ensureVisibleAnimated(list.selectedIndex)
        }
    }
    Shortcut {
        sequence: "Ctrl+U"
        enabled: wallRoot.visible
        onActivated: {
            list.animSpeed = wallRoot.speed * 7
            list.selectedIndex = list.clampIndex(list.selectedIndex - 7)
            list.ensureVisibleAnimated(list.selectedIndex)
        }
    }
    Shortcut {
        sequence: "Return"
        enabled: wallRoot.visible
        onActivated: list.activateCurrent()
    }

    // ------------------------------------------

    Component.onCompleted: {
        Quickshell.execDetached(["bash", Quickshell.shellPath("cache.sh"), Quickshell.shellDir])
    }

    FolderListModel {
        id: folderModel
        folder: "file:///home/randomguy/Pictures/Wallpapers/"
        showDirs: false
        nameFilters: ["*.png","*.jpg"]
        sortField: FolderListModel.Name
    }

    ListView {
        id: list
        anchors.fill: parent

        model: folderModel
        orientation: ListView.Horizontal
        spacing: 4
        clip: true
        cacheBuffer: width * 2

        property int selectedIndex: 0
        property real tileWidth: width / 7 - 10
        property int animSpeed: wallRoot.speed

        // 1. A timer to prevent system lag when scrolling rapidly
        Timer {
            id: previewTimer
            interval: 150 // Waits 150ms after you stop scrolling before running wallust
            repeat: false
            onTriggered: {
                let path = folderModel.get(list.selectedIndex, "filePath")
                if (path) {
                    // Ensure we are passing a normal path, stripping 'file://' if QML adds it
                    if (path.startsWith("file://")) path = path.substring(7)
                    Quickshell.execDetached(["wallust", "run", path])
                }
            }
        }

        // 2. Trigger the timer every time the selection changes
        onSelectedIndexChanged: {
            previewTimer.restart()
        }

        function clampIndex(i) {
            return Math.max(0, Math.min(i, count - 1))
        }

        // 3. Update the activation function with the awww command
        function activateCurrent() {
            let path = folderModel.get(selectedIndex, "filePath")
            if (path) {
                if (path.startsWith("file://")) path = path.substring(7)

                // Tell the rollback logic to cancel
                wallRoot.wallpaperSelected = true

                Quickshell.execDetached(["awww", "img", path, "-t", "grow", "--transition-duration", "1"])
                Quickshell.execDetached(["cp", path, "/home/randomguy/Pictures/wallpaper.png"])
                Quickshell.execDetached(["cp", path, "/home/randomguy/Pictures/wallpaper_def.png"])
            }
            if (main) main.isOpen = false
        }

        function clampX(x) {
            return Math.max(0, Math.min(x, contentWidth - width))
        }

        function ensureVisibleAnimated(i) {
            const step = tileWidth + spacing
            const itemStart = i * step
            const itemEnd = itemStart + tileWidth + 20

            if (itemStart < contentX)
            contentX = clampX(itemStart)
            else if (itemEnd > contentX + width)
            contentX = clampX(itemStart - (width - step))
        }

        Behavior on contentX {
            SmoothedAnimation {
                property int v: list.animSpeed
                duration: 100
            }
        }

        delegate: Item {
            property bool active: index === list.selectedIndex
            width: list.tileWidth
            height: 500

            Behavior on width {
                NumberAnimation {
                    duration: 50
                    easing.type: Easing.OutCubic
                }
            }

            Text {
                id: alt
                text: "Loading..."
                color: "#C27B63"
                anchors.centerIn: parent
                font.pixelSize: 16
                transform: Shear { xFactor: -0.25 }
            }

            Image {
                id: img
                anchors.fill: parent
                fillMode: Image.PreserveAspectCrop

                asynchronous: true
                cache: false
                smooth: true

                source: "file:///home/randomguy/.cache/quickshell/thumbs/" + fileName

                sourceSize.width: width
                sourceSize.height: height
                transform: Shear { xFactor: -0.25 }

                Timer {
                    id: retryTimer
                    interval: 1000
                    repeat: false
                    onTriggered: {
                        let s = img.source
                        img.source = ""
                        img.source = s
                    }
                }

                onStatusChanged: {
                    if (status === Image.Error) {
                        alt.text = "Caching"
                        retryTimer.start()
                    }
                }
            }

            Rectangle {
                id: border
                z: 10
                visible: parent.active
                width: list.tileWidth
                height: 500
                color: "transparent"

                border.width: 4
                border.color: "#C27B63"
                transform: Shear { xFactor: -0.25 }
            }

            MouseArea {
                anchors.fill: parent

                onClicked: {
                    list.selectedIndex = index
                    list.activateCurrent()
                }

                onWheel: function(wheel) {
                    list.contentX = list.clampX(
                        list.contentX - wheel.angleDelta.y * 2
                    )
                    wheel.accepted = false
                }
            }
        }
    }
}
