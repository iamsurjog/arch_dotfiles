import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Widgets

//BUG: Hovering apps removes focus from typing

Rectangle {
    id: appDrawer
    width: 400
    // Hug the result list rather than always reserving a fixed slab of space
    height: Math.max(Math.min(appList.contentHeight + 20, 480), 64)
    radius: 16
    clip: true
    color: theme.fade(colors.background, 0.94)
    border.width: 1
    border.color: theme.line

    property string searchQuery: ""

    // THIS IS REQUIRED to catch key events if there is no text input field inside this component
    focus: true

    property var allApps: {
        if (!DesktopEntries.applications) return []

        let apps = DesktopEntries.applications.values ? [...DesktopEntries.applications.values] : []

        return apps
        .filter(app => app && !app.noDisplay)
        .sort((a, b) => a.name.localeCompare(b.name))
    }

    property var filteredApps: {
        let q = searchQuery.trim().toLowerCase()
        if (q === "") return allApps

        return allApps.filter(app => {
                let n = app.name ? app.name.toLowerCase() : ""
                let gn = app.genericName ? app.genericName.toLowerCase() : ""
                let desc = app.comment ? app.comment.toLowerCase() : ""

                return n.includes(q) || gn.includes(q) || desc.includes(q)
        })
    }

    onSearchQueryChanged: {
        appList.currentIndex = filteredApps.length > 0 ? 0 : -1
        console.log()

    }

    ListView {
        id: appList
        anchors.fill: parent
        anchors.margins: 10
        clip: true
        spacing: 4
        highlightMoveDuration: 100

        model: appDrawer.filteredApps

        delegate: ItemDelegate {
            id: delegate
            width: ListView.view.width
            height: 48
            hoverEnabled: true

            onHoveredChanged: {
                if (hovered)
                appList.currentIndex = index
            }

            highlighted: ListView.isCurrentItem

            contentItem: RowLayout {
                anchors.fill: parent
                anchors.leftMargin: 12
                anchors.rightMargin: 12
                spacing: 12

                IconImage {
                    source: modelData.icon
                    ? Quickshell.iconPath(modelData.icon)
                    : ""

                    Layout.preferredWidth: 30
                    Layout.preferredHeight: 30
                    Layout.alignment: Qt.AlignVCenter | Qt.AlignLeft
                }

                ColumnLayout {
                    spacing: 2
                    Layout.fillWidth: true
                    Layout.alignment: Qt.AlignVCenter | Qt.AlignLeft

                    Text {
                        text: modelData.name || "Unknown"
                        color: theme.text
                        font.pixelSize: 15
                        Layout.fillWidth: true
                        elide: Text.ElideRight
                    }

                    Text {
                        text: modelData.genericName || modelData.comment || ""
                        color: theme.textDim
                        font.pixelSize: 11
                        visible: text !== ""
                        Layout.fillWidth: true
                        elide: Text.ElideRight
                    }
                }
            }

            background: Rectangle {
                radius: 10
                color: delegate.highlighted ? theme.fade(colors.color10, 0.32) : "transparent"
                border.width: 1
                border.color: delegate.highlighted ? theme.fade(colors.cursor, 0.45) : "transparent"

                Behavior on color {
                    ColorAnimation {
                        duration: 120
                    }
                }
                Behavior on border.color {
                    ColorAnimation {
                        duration: 120
                    }
                }
            }

            onClicked: {
                appList.currentIndex = index
                appDrawer.launchSelected()
            }
        }

    }

    // Shown when nothing matches the query
    Text {
        anchors.centerIn: parent
        text: "No matches"
        color: theme.textMute
        font.pixelSize: 15
        visible: appDrawer.filteredApps.length === 0
    }

    function launchSelected() {
        if (appList.currentIndex >= 0 && appList.currentIndex < filteredApps.length) {
            let target = filteredApps[appList.currentIndex]

            if (target && typeof target.execute === "function") {
                target.execute()
                appDrawer.searchQuery = ""
                inputField.text = ""
            }
        }
    }

    function nextItem() {
        appList.currentIndex = Math.min(appList.currentIndex + 1, appList.count - 1)
    }

    function previousItem() {
        appList.currentIndex = Math.max(appList.currentIndex - 1, 0)
    }
}
