// KeyBinds.qml
import QtQuick

Item {
    id: root
    property var panelRoot

    Shortcut {
        sequence: "Escape"

        onActivated: root.panelRoot.isOpen = false
    }
}
