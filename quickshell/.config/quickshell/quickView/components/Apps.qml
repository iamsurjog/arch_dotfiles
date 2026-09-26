import QtQuick

Rectangle {
    id: root
    // Declare the property here so Launcher.qml can inject data into itj
    property string searchQuery: launcher.searchQuery
    
    width: 200 // Made wider so you can see the text
    height: 100 // Hardcoded for testing so it definitely drops down
    color: typeof colors !== "undefined" ? colors.color12 : "red"
    
    Text {
        anchors.centerIn: parent
        // Reference the local property, not launcher.searchQuery
        text: root.searchQuery === "" ? "Empty" : root.searchQuery 
        color: typeof colors !== "undefined" ? colors.color0 : "black"
    }
}
