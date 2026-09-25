// KeyBinds.qml
import QtQuick

Item {
    Shortcut {
        sequence: "Escape"
        
        // Kills the Quickshell process entirely
        onActivated: Qt.quit() 
    }
}
