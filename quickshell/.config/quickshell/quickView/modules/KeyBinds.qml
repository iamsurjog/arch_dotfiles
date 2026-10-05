import QtQuick
import Quickshell

Item {
    id: root
    property var panelRoot

    Shortcut {
        sequence: "Escape"

        onActivated: root.panelRoot.isOpen = false
    }
    Shortcut {
        sequence: "Ctrl+S"

        onActivated: {
            Quickshell.execDetached(["wlogout", "-b", "4", "-T", "380", "-B", "380"])
            root.panelRoot.isOpen = false
        }
    }
}
