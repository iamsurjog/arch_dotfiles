import QtQuick
import QtQuick.Controls

Item {
    width: 40
    height: 40

    Button {
        id: button
        text: "L"
        anchors.fill: parent
        onClicked: popup.open()
    }

    Popup {
        id: popup
        width: 200
        height: 300
        x: button.width
        y: 0

        ListView {
            anchors.fill: parent
            model: ["App 1", "App 2", "App 3", "App 4", "App 5"]
            delegate: ItemDelegate {
                text: modelData
                width: parent.width
            }
        }
    }
}
