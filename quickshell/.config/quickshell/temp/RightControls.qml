import QtQuick
import QtQuick.Controls

Item {
    width: 40
    height: 40

    Button {
        id: button
        text: "R"
        anchors.fill: parent
        onClicked: popup.open()
    }

    Popup {
        id: popup
        width: 150
        height: 200
        x: -width
        y: 0

        Column {
            anchors.fill: parent
            padding: 10
            spacing: 10

            Label {
                text: "Volume"
            }
            Slider {
                width: parent.width
            }

            Label {
                text: "Brightness"
            }
            Slider {
                width: parent.width
            }
        }
    }
}
