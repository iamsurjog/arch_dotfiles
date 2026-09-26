import QtQuick
import Quickshell

Rectangle {
    id: launcher

    property bool typing: inputField.text.trim().length > 0
    property bool wallpaperMode: inputField.text.trim().toLowerCase().startsWith("/wall")
    property string searchQuery: inputField.text

    width: 200
    height: main.trayHeight
    color: typeof colors !== "undefined" ? colors.color9 : "#313244"
    radius: 6

    TextInput {
        id: inputField
        anchors.fill: parent
        anchors.leftMargin: 12
        anchors.rightMargin: 12
        verticalAlignment: TextInput.AlignVCenter
        color: typeof colors !== "undefined" ? colors.foreground : "#cdd6f4"
        font.pixelSize: 16
        clip: true

        cursorVisible: false
        cursorDelegate: Item {}

        focus: true
        Component.onCompleted: forceActiveFocus()

        MouseArea {
            anchors.fill: parent
            cursorShape: Qt.BlankCursor
            onClicked: inputField.forceActiveFocus()
        }

        Keys.onPressed: (event) => {
            // Down Arrow OR Ctrl + N
            if (event.key === Qt.Key_Down || (event.modifiers & Qt.ControlModifier && event.key === Qt.Key_N)) {
                appMenu.nextItem()
                event.accepted = true
            }
            // Up Arrow OR Ctrl + P
            else if (event.key === Qt.Key_Up || (event.modifiers & Qt.ControlModifier && event.key === Qt.Key_P)) {
                appMenu.previousItem()
                event.accepted = true
            }
            // Enter / Return
            else if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
                appMenu.launchSelected()
                event.accepted = true
                Qt.quit()
            }
        }
    }

    // Creates a native Wayland surface that drops down seamlessly
    PopupWindow {
        id: launcherPopup
        visible: launcher.typing
        implicitWidth: menuContent.width
        implicitHeight: menuContent.height

        anchor {
            window: main
            // Map the coordinates so it drops exactly below the text input
            rect.x: launcher.mapToItem(main.contentItem, 0, 0).x
            rect.y: launcher.mapToItem(main.contentItem, 0, 0).y
            rect.width: Screen.width / 2 + launcher.width * 2 + 50
            rect.height: launcher.height
            edges: Edges.Bottom
        }

        // Popup background must be transparent so only the custom menus show
        color: "transparent"

        Item {
            id: menuContent
            width: 400
            height: launcher.wallpaperMode ? wallMenu.height : appMenu.height

            Apps {
                id: appMenu
                width: parent.width
                visible: launcher.typing && !launcher.wallpaperMode
                searchQuery: launcher.searchQuery
            }

            Wallpaper {
                id: wallMenu
                width: parent.width
                visible: launcher.typing && launcher.wallpaperMode
            }

        }
    }
}
