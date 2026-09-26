import QtQuick
import Quickshell

import "menus"

Rectangle {
    id: launcher

    property bool typing: inputField.text.trim().length > 0
    property bool wallpaperMode: inputField.text.trim().toLowerCase().startsWith("/wall")
    property string searchQuery: inputField.text

    function focusInput() {
        if (main.isOpen)
        inputField.forceActiveFocus()
    }

    // Showing the dropdown PopupWindow can move keyboard focus away from the input
    // field (the popup is a separate window). Re-assert focus whenever the popup is
    // created or destroyed so typing never dies mid-word.
    onTypingChanged: {
        if (typing)
        Qt.callLater(() => launcher.focusInput())
    }

    function activate() {
        inputField.clear()
        inputField.forceActiveFocus()
    }

    function resetInput() {
        inputField.clear()
    }

    width: 200
    height: main.trayHeight
    color: typeof colors !== "undefined" ? colors.background : "#313244"
    border.width: 2
    border.color: colors.color5

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

        onActiveFocusChanged: {
            if (!activeFocus && main.isOpen) {
                Qt.callLater(() => launcher.focusInput())
            }
        }

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
                main.isOpen = false
            }
        }
    }

    // Creates a native Wayland surface that drops down seamlessly
    // 1. Replace PopupWindow with PanelWindow
    PopupWindow {
        id: launcherPopup
        visible: launcher.typing
        
        // This is the Quickshell-specific property to prevent focus stealing on launch
        grabFocus: false
        
        implicitWidth: menuContent.width
        implicitHeight: menuContent.height

        anchor {
            window: main
            rect.x: launcher.mapToItem(main.contentItem, 0, 0).x
            rect.y: launcher.mapToItem(main.contentItem, 0, 0).y
            rect.width: Screen.width / 2 + launcher.width * 2 + 50
            rect.height: launcher.height
            edges: Edges.Bottom
        }

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
