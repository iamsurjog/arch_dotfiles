//@ pragma UseQApplication
//@ pragma Env QT_QUICK_CONTROLS_STYLE=Basic


import Quickshell
import Quickshell.Io // for Process
import QtQuick
import Qt.labs.folderlistmodel

PanelWindow {
    id: mainWindow
    property bool hovering: false
    property string path: "/home/randomguy/surjo/todos/"
    color: "transparent"
    anchors {
        right: true
        bottom: true
    }
    margins {
        right: hovering ? 0 : -width + 2
        bottom: 5
    }
    implicitHeight: Screen.desktopAvailableHeight - 60
    aboveWindows: true
    exclusiveZone: 1
    implicitWidth: 500
    FileView {
        path: Quickshell.shellPath("colors.json")

        // when changes are made on disk, reload the file's content
        watchChanges: true
        onFileChanged: this.reload()

        // when changes are made to properties in the adapter, save them
        onAdapterUpdated: writeAdapter()

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

    FolderListModel {
        id: folderModel

        folder: "file://" + path   // MUST be file:// URL
        showDirs: true
        showFiles: true
        nameFilters: ["*"]        // or ["*.txt"]
        sortField: FolderListModel.Name
        sortReversed: false
    }


    Rectangle {
        anchors.fill: parent
        radius: 10
        color: "transparent"  // Your background color
        border.width: 2
        border.color: colors.color14  // Optional

        layer.enabled: true  // Enables smooth rendering for radius/clip
        layer.smooth: true   // Anti-aliases edges

        clip: true  // Clips children to rounded bounds

        HoverHandler {
            onHoveredChanged: hovering = hovered
        }



        Flickable {
            anchors.fill: parent
            contentHeight: column.height
            clip: true

            Column {
                id: column
                width: parent.width - 2
                Rectangle {
                    id: myButton
                    width: parent.width
                    height: 40
                    color: mouseArea.pressed ? colors.color2 : colors.color12
                    radius: 5 // Optional: rounded corners

                    Text {
                        anchors.centerIn: parent
                        text: "Add Task"
                    }

                    MouseArea {
                        id: mouseArea
                        anchors.fill: parent
                        onClicked: {
                            onClicked: Quickshell.execDetached(["kitty", "nvim", path])

                        }
                    }
                }

                Repeater {
                    model: folderModel
                    Rectangle {
                        width: column.width
                        height: 40
                        radius: 8
                        color: hover ? colors.color11 : "transparent"

                        property bool hover: false

                        Behavior on color {
                            ColorAnimation { duration: 120 }
                        }

                        Row {
                            anchors.fill: parent
                            anchors.margins: 8
                            spacing: 10

                            Text {
                                text: fileBaseName
                                color: colors.foreground
                                font.family: "Kode Mono"
                                font.pixelSize: 18
                                width: parent.width - 80
                                elide: Text.ElideRight
                                MouseArea {
                                    anchors.fill: parent
                                    onClicked: Quickshell.execDetached(["bash", filePath])
                                }
                            }

                            // ✔ open
                            Text {
                                text: "🖉"
                                color: colors.foreground
                                font.family: "Kode Mono"
                                font.pixelSize: 18

                                MouseArea {
                                    anchors.fill: parent
                                    onClicked: Quickshell.execDetached(["kitty", "nvim", filePath])
                                }
                            }

                            // ✖ delete
                            Text {
                                text: "✖"
                                font.pixelSize: 18
                                color: colors.foreground
                                font.family: "Kode Mono"

                                MouseArea {
                                    anchors.fill: parent
                                    onClicked: Quickshell.execDetached(["rm", "-f", filePath])
                                }
                            }
                        }

                        MouseArea {
                            anchors.fill: parent
                            hoverEnabled: true
                            propagateComposedEvents: true

                            onEntered: parent.hover = true
                            onExited: parent.hover = false

                            // onClicked: {
                            //     Quickshell.execDetached(["bash", filePath])   // run script
                            // }
                        }
                    }
                }
            }
        }

    }
}
