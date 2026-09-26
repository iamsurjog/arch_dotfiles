import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Widgets

Rectangle {
    id: appDrawer
    width: 400
    height: 500
    color: typeof colors !== "undefined" ? colors.color0 : "#1e1e2e"
    radius: 8
    border.color: typeof colors !== "undefined" ? colors.color1 : "#313244"
    border.width: 1

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
    }

    ListView {
        id: appList
        anchors.fill: parent
        anchors.margins: 12
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

                    Layout.preferredWidth: 32
                    Layout.preferredHeight: 32
                    Layout.alignment: Qt.AlignVCenter | Qt.AlignLeft
                }

                ColumnLayout {
                    spacing: 2
                    Layout.fillWidth: true
                    Layout.alignment: Qt.AlignVCenter | Qt.AlignLeft

                    Text {
                        text: modelData.name || "Unknown"
                        color: typeof colors !== "undefined"
                        ? colors.color15
                        : "#cdd6f4"
                        font.pixelSize: 15
                        Layout.fillWidth: true
                        elide: Text.ElideRight
                    }

                    Text {
                        text: modelData.genericName || modelData.comment || ""
                        color: typeof colors !== "undefined"
                        ? colors.color14
                        : "#a6adc8"
                        font.pixelSize: 11
                        visible: text !== ""
                        Layout.fillWidth: true
                        elide: Text.ElideRight
                    }
                }
            }

            background: Rectangle {
                color: delegate.highlighted
                ? (typeof colors !== "undefined"
                    ? colors.color2
                    : "#45475a")
                : "transparent"
                radius: 4
            }

            onClicked: {
                appList.currentIndex = index
                appDrawer.launchSelected()
            }
        }

    }

    function launchSelected() {
        if (appList.currentIndex >= 0 && appList.currentIndex < filteredApps.length) {
            let target = filteredApps[appList.currentIndex]

            if (target && typeof target.execute === "function") {
                target.execute()
                appDrawer.searchQuery = ""
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
