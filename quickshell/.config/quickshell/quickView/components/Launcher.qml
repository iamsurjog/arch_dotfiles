import QtQuick
import Quickshell

import "menus"

Rectangle {
    id: launcher

    property bool typing: inputField.text.trim().length > 0
    property bool wallpaperMode: inputField.text.trim().toLowerCase().startsWith("/wall")
    property string searchQuery: inputField.text

    onSearchQueryChanged: {
        appMenu.searchQuery = searchQuery
    }

    function activate() {
        inputField.clear()
        inputField.forceActiveFocus()
    }

    function resetInput() {
        inputField.clear()
    }

    width: 280
    height: main.trayHeight
    radius: 14
    clip: true

    // Reads as an inset well until it is focused, then the accent ring shows up
    color: inputField.activeFocus ? theme.field : theme.fade(colors.background, 0.55)
    border.width: 1
    border.color: inputField.activeFocus ? theme.ring : theme.line

    Behavior on color {
        ColorAnimation {
            duration: 160
        }
    }
    Behavior on border.color {
        ColorAnimation {
            duration: 160
        }
    }

    TextInput {
        id: inputField
        anchors.fill: parent
        anchors.leftMargin: 14
        anchors.rightMargin: 14
        verticalAlignment: TextInput.AlignVCenter
        color: theme.text
        font.pixelSize: 16
        clip: true

        cursorVisible: false
        cursorDelegate: Item {}

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
            // Ctrl + W (Auto-fill wallpaper mode)
            else if (event.modifiers & Qt.ControlModifier && event.key === Qt.Key_W) {
                inputField.text = "/wall " 
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

    // Hint shown while the field is empty (sits above the input but lets
    // clicks fall through to it)
    Text {
        anchors.fill: parent
        anchors.leftMargin: 14
        anchors.rightMargin: 14
        verticalAlignment: Text.AlignVCenter
        text: "Search apps…"
        color: theme.textMute
        font.pixelSize: 16
        visible: inputField.text.length === 0
    }

    // Creates a native Wayland surface that drops down seamlessly
    PopupWindow {
        id: launcherPopup
        visible: launcher.typing
        implicitWidth: menuContent.width
        implicitHeight: menuContent.height

        anchor {
            window: main
            // Centre the drop down on the search field instead of the window edge
            rect.x: topBar.x + launcher.x + (launcher.width - menuContent.width) / 2
            // Map the coordinates so it drops exactly below the text input
            rect.height: topBar.height + topBar.x
            edges: Edges.Bottom
        }

        // Popup background must be transparent so only the custom menus show
        color: "transparent"

        Item {
            id: menuContent
            width: launcher.wallpaperMode ? main.width : 400 
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
