import Quickshell
import Quickshell.Io
import QtQuick
import QtQuick.Layouts
import Quickshell.Services.UPower

Rectangle {
    id: datetime
    radius: 14
    color: theme.raised
    border.width: 1
    border.color: theme.lineSoft

    // Force the Rectangle to size itself to the internal layout + margins
    implicitWidth: layout.implicitWidth + 30
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
            datetime.timeString = Qt.formatTime(now, "hh:mm AP")
            datetime.dateString = Qt.formatDate(now, "ddd, MMM d")
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
        spacing: 14

        // Clock Block
        ColumnLayout {
            spacing: 2

            Text {
                text: datetime.timeString
                color: theme.text
                font.pixelSize: 18
                font.bold: true
            }
            Text {
                text: datetime.dateString
                color: theme.textDim
                font.pixelSize: 12
            }
        }

        // Divider
        Rectangle {
            Layout.preferredWidth: 1
            Layout.preferredHeight: 30
            radius: 0.5
            color: theme.fade(colors.foreground, 0.16)
            visible: battery !== null && battery.isPresent
        }

        // Battery Block
        RowLayout {
            spacing: 7
            visible: battery !== null && battery.isPresent
            opacity: mouseArea.containsMouse ? 0.7 : 1.0

            Text {
                text: datetime.isCharging ? "⚡" : (batPercent > 20 ? "🔋" : "🪫")
                color: datetime.isCharging ? theme.accent : theme.text
                font.pixelSize: 16
                // Visual indicator: lower opacity when hovered

            }

            Text {
                text: Math.round(datetime.batPercent) + "%"
                color: theme.text
                font.pixelSize: 16
                font.bold: true
            }
            MouseArea {
                id: mouseArea
                // Layout.alignment.fill: parent
                anchors.fill: parent

                hoverEnabled: true // Required to track containsMouse without clicking
                cursorShape: Qt.PointingHandCursor

                onClicked: {
                    // Fixed the missing comma syntax error here
                    Quickshell.execDetached(["wlogout", "-b", "4", "-T", "380", "-B", "380"])
                    datetime.panelRoot.isOpen = false
                }
            }
        }
    }
}
