import QtQuick
import Quickshell

Rectangle {
    id: launcher
    
    property bool typing: inputField.text.length <= 0
    property bool apps: inputField.text.trim().startsWith("/wall")
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
    }

    // Creates a native Wayland surface that drops down seamlessly
    PopupWindow {
        id: launcherPopup
        visible: launcher.typing
        
        anchor {
            window: main
            // Map the coordinates so it drops exactly below the text input
            rect.x: launcher.mapToItem(main, 0, 0).x
            rect.y: launcher.mapToItem(main, 0, 0).y
            rect.width: launcher.width
            rect.height: launcher.height
            edges: Edges.Bottom
        }

        // Popup background must be transparent so only the custom menus show
        color: "transparent"

        Item {
            width: 400
            // Dynamically size the container based on which menu is active
            height: wallMenu.visible ? wallMenu.height : (appMenu.visible ? appMenu.height : 0)

        }
    }
}
