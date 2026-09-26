import QtQuick
import QtQuick.Layouts
import Quickshell.Services.UPower

Rectangle {
    id: root
    color: "transparent"
    radius: 8

    // Force the Rectangle to size itself to the internal layout + margins
    implicitWidth: layout.implicitWidth + 24
    implicitHeight: layout.implicitHeight + 16

    property string timeString: ""
    property string dateString: ""

    // Foolproof standard Qt clock
    Timer {
        interval: 1000
        running: true
        repeat: true
        onTriggered: {
            let now = new Date()
            root.timeString = Qt.formatTime(now, "hh:mm AP")
            root.dateString = Qt.formatDate(now, "ddd, MMM d")
        }
        Component.onCompleted: triggered() // Run once immediately on load
    }

    // Grab the system's primary merged display battery via DBus
    property var battery: UPower.displayDevice
    
    // Map UPower device states directly
    property bool isCharging: battery && (battery.state === UPowerDeviceState.Charging || battery.state === UPowerDeviceState.FullyCharged)
    property real batPercent: battery ? (battery.percentage * 100) : 0

    RowLayout {
        id: layout
        anchors.centerIn: parent
        spacing: 16


        // Clock Block
        ColumnLayout {
            spacing: 2
            
            Text {
                text: root.timeString
                color: typeof colors !== "undefined" ? colors.foreground : "#cdd6f4"
                font.pixelSize: 18
                font.bold: true
            }
            Text {
                text: root.dateString
                color: typeof colors !== "undefined" ? colors.color8 : "#a6adc8"
                font.pixelSize: 12
            }
        }

        // Divider
        Rectangle {
            Layout.preferredWidth: 2
            Layout.fillHeight: true
            color: typeof colors !== "undefined" ? colors.color0 : "#313244"
            visible: battery !== null && battery.isPresent
        }

        // Battery Block
        RowLayout {
            spacing: 6
            visible: battery !== null && battery.isPresent
            
            Text {
                text: root.isCharging ? "⚡" : (root.batPercent > 20 ? "🔋" : "🪫")
                color: root.isCharging ? (typeof colors !== "undefined" ? colors.color2 : "#a6e3a1") 
                                       : (typeof colors !== "undefined" ? colors.foreground : "#cdd6f4")
                font.pixelSize: 16
            }
            
            Text {
                text: Math.round(root.batPercent) + "%"
                color: typeof colors !== "undefined" ? colors.foreground : "#cdd6f4"
                font.pixelSize: 16
                font.bold: true
            }
        }
    }
}
