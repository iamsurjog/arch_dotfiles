import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Widgets

Rectangle {
    id: appDrawer
    width: 400
    height: 500
    color: 'transparent'
    radius: 8

    property string searchQuery: ""

    // Keyboard focus belongs entirely to Launcher.qml
    focus: false

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

        // 1. Physically disable kinetic dragging/flicking in the C++ backend
        interactive: false

        // 2. Prevent the ListView from ever capturing active focus
        focusPolicy: Qt.NoFocus
        focus: false

        model: appDrawer.filteredApps

        delegate: Item {
            id: delegate
            width: ListView.view.width
            height: 48
            
            // Absolutely no focusPolicy or hoverEnabled properties here

            Rectangle {
                anchors.fill: parent
                color: ListView.isCurrentItem
                    ? (typeof colors !== "undefined" ? colors.color2 : "#45475a")
                    : "transparent"
                radius: 4
            }

            RowLayout {
                anchors.fill: parent
                anchors.leftMargin: 12
                anchors.rightMargin: 12
                spacing: 12

                IconImage {
                    source: modelData.icon ? Quickshell.iconPath(modelData.icon) : ""
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
                        color: typeof colors !== "undefined" ? colors.color15 : "#cdd6f4"
                        font.pixelSize: 15
                        Layout.fillWidth: true
                        elide: Text.ElideRight
                    }

                    Text {
                        text: modelData.genericName || modelData.comment || ""
                        color: typeof colors !== "undefined" ? colors.color14 : "#a6adc8"
                        font.pixelSize: 11
                        visible: text !== ""
                        Layout.fillWidth: true
                        elide: Text.ElideRight
                    }
                }
            }
        }
    }

    // 3. THE SHIELD: Must remain at the absolute bottom of this file.
    // It sits invisibly on top of the ListView and devours all pointer input.
    MouseArea {
        anchors.fill: parent
        acceptedButtons: Qt.AllButtons
        hoverEnabled: true
        
        // Swallow every conceivable mouse interaction before the ListView or Window sees it
        onWheel: (wheel) => { wheel.accepted = true }
        onPressed: (mouse) => { mouse.accepted = true }
        onReleased: (mouse) => { mouse.accepted = true }
        onPositionChanged: (mouse) => { mouse.accepted = true }
    }

    // --- Keyboard Navigation Functions ---
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
