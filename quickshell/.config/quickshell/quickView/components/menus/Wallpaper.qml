import Quickshell
import Quickshell.Io
import QtQuick
import Qt.labs.folderlistmodel

Item {
    id: wallRoot
    implicitHeight: 500

    property int speed: 5000
    property bool wallpaperSelected: false


    onVisibleChanged: {
        if (visible) {
            wallpaperSelected = false
            list.forceActiveFocus()
        } else if (!wallpaperSelected) {
            Quickshell.execDetached(["wallust", "run", "/home/randomguy/Pictures/wallpaper.png"])
        }
    }

    Shortcut {
        sequence: "Ctrl+J"
        enabled: wallRoot.visible
        onActivated: list.incrementCurrentIndex()
    }
    Shortcut {
        sequence: "Ctrl+K"
        enabled: wallRoot.visible
        onActivated: list.decrementCurrentIndex()
    }
    Shortcut {
        sequence: "Ctrl+F"
        enabled: wallRoot.visible
        onActivated: list.currentIndex = Math.min(list.count - 1, list.currentIndex + 7)
    }
    Shortcut {
        sequence: "Ctrl+B"
        enabled: wallRoot.visible
        onActivated: list.currentIndex = Math.max(0, list.currentIndex - 7)
    }
    Shortcut {
        sequence: "Return"
        enabled: wallRoot.visible
        onActivated: list.activateCurrent()
    }

    Component.onCompleted: {
        Quickshell.execDetached(["bash", Quickshell.shellPath("cache.sh"), Quickshell.shellDir])
    }

    FolderListModel {
        id: folderModel
        folder: "file:///home/randomguy/Pictures/Wallpapers/"
        showDirs: false
        nameFilters: ["*.png", "*.jpg"]
        sortField: FolderListModel.Name
    }

    ListView {
        id: list
        anchors.fill: parent
        model: folderModel
        orientation: ListView.Horizontal
        spacing: 12
        clip: true
        cacheBuffer: width * 2

        property real tileWidth: width / 7 - 10
        
        // Native automatic scrolling to keep current item visible
        highlightFollowsCurrentItem: true
        highlightMoveDuration: 250
        preferredHighlightBegin: width * 0.1
        preferredHighlightEnd: width * 0.9
        highlightRangeMode: ListView.ApplyRange

        Timer {
            id: previewTimer
            interval: 150
            repeat: false
            onTriggered: {
                let path = folderModel.get(list.currentIndex, "filePath")
                if (path) {
                    if (path.startsWith("file://")) path = path.substring(7)
                    Quickshell.execDetached(["wallust", "run", path])
                }
            }
        }

        onCurrentIndexChanged: {
            previewTimer.restart()
        }

        function activateCurrent() {
            let path = folderModel.get(currentIndex, "filePath")
            if (path) {
                if (path.startsWith("file://")) path = path.substring(7)

                wallRoot.wallpaperSelected = true

                Quickshell.execDetached(["awww", "img", path, "-t", "grow", "--transition-duration", "1"])
                Quickshell.execDetached(["cp", path, "/home/randomguy/Pictures/wallpaper.png"])
                Quickshell.execDetached(["cp", path, "/home/randomguy/Pictures/wallpaper_def.png"])
            }
            if (typeof main !== "undefined" && main) main.isOpen = false
        }

        delegate: Item {
            id: delegateRoot
            width: list.tileWidth
            height: 500
            
            // Visual polish: Scale up and increase opacity when active
            scale: ListView.isCurrentItem ? 1.05 : 0.95
            opacity: ListView.isCurrentItem ? 1.0 : 0.5
            z: ListView.isCurrentItem ? 10 : 1

            Behavior on scale {
                NumberAnimation { duration: 200; easing.type: Easing.OutBack }
            }
            Behavior on opacity {
                NumberAnimation { duration: 200 }
            }

            Text {
                id: altText
                text: "Loading..."
                color: ListView.isCurrentItem ? "#E29B83" : "#C27B63"
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
                
                // Fade in smoothly when loaded
                opacity: status === Image.Ready ? 1.0 : 0.0
                Behavior on opacity { NumberAnimation { duration: 300 } }

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
                        altText.text = "Caching..."
                        retryTimer.start()
                    }
                }
            }

            Rectangle {
                id: border
                anchors.fill: parent
                color: "transparent"
                border.width: ListView.isCurrentItem ? 5 : 2
                border.color: ListView.isCurrentItem ? theme.accent : theme.accentSoft
                transform: Shear { xFactor: -0.25 }
                
                Behavior on border.color { ColorAnimation { duration: 200 } }
                Behavior on border.width { NumberAnimation { duration: 200 } }
            }

            MouseArea {
                anchors.fill: parent
                hoverEnabled: true
                
                onClicked: {
                    if (list.currentIndex === index) {
                        list.activateCurrent()
                    } else {
                        list.currentIndex = index
                    }
                }

                onWheel: (wheel) => {
                    if (wheel.angleDelta.y > 0) {
                        list.decrementCurrentIndex()
                    } else {
                        list.incrementCurrentIndex()
                    }
                    wheel.accepted = true
                }
            }
        }
    }
}
