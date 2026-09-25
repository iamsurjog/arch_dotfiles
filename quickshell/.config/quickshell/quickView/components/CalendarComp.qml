import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

Rectangle {
    id: root
    color: typeof colors !== "undefined" ? colors.background : "#1e1e2e"
    radius: 8

    // Track the current real-world date
    property date today: new Date()
    
    // Track the currently viewed month and year (defaults to today's month)
    property int viewMonth: today.getMonth()
    property int viewYear: today.getFullYear()

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 16
        spacing: 12

        // Header: Navigation and Month/Year Label
        RowLayout {
            Layout.fillWidth: true

            // Previous Month Button
            Text {
                text: "<"
                color: typeof colors !== "undefined" ? colors.color5 : "#89b4fa"
                font.pixelSize: 20
                font.bold: true
                
                MouseArea {
                    anchors.fill: parent
                    anchors.margins: -10 // Increase hit area for easier clicking
                    cursorShape: Qt.PointingHandCursor
                    onClicked: {
                        if (root.viewMonth === 0) {
                            root.viewMonth = 11
                            root.viewYear--
                        } else {
                            root.viewMonth--
                        }
                    }
                }
            }

            Item { Layout.fillWidth: true } // Spacer

            // Month and Year Text
            Text {
                text: Qt.formatDate(new Date(root.viewYear, root.viewMonth, 1), "MMMM yyyy")
                color: typeof colors !== "undefined" ? colors.foreground : "#cdd6f4"
                font.pixelSize: 16
                font.bold: true
            }

            Item { Layout.fillWidth: true } // Spacer

            // Next Month Button
            Text {
                text: ">"
                color: typeof colors !== "undefined" ? colors.color5 : "#89b4fa"
                font.pixelSize: 20
                font.bold: true
                
                MouseArea {
                    anchors.fill: parent
                    anchors.margins: -10
                    cursorShape: Qt.PointingHandCursor
                    onClicked: {
                        if (root.viewMonth === 11) {
                            root.viewMonth = 0
                            root.viewYear++
                        } else {
                            root.viewMonth++
                        }
                    }
                }
            }
        }

        // Days of the Week Header (S M T W T F S)
        DayOfWeekRow {
            Layout.fillWidth: true
            locale: Qt.locale() 
            
            delegate: Text {
                text: model.shortName
                color: typeof colors !== "undefined" ? colors.color8 : "#7f849c"
                font.pixelSize: 12
                font.bold: true
                horizontalAlignment: Text.AlignHCenter
            }
        }

        // The Main Calendar Grid
        MonthGrid {
            id: grid
            Layout.fillWidth: true
            Layout.fillHeight: true
            month: root.viewMonth
            year: root.viewYear
            locale: Qt.locale()

            delegate: Rectangle {
                color: "transparent"

                // Check if this specific grid cell represents today's real date
                property bool isToday: model.date.getDate() === root.today.getDate() &&
                                       model.date.getMonth() === root.today.getMonth() &&
                                       model.date.getFullYear() === root.today.getFullYear()

                // Highlight today with a border
                border.width: isToday ? 2 : 0
                border.color: typeof colors !== "undefined" ? colors.color5 : "#89b4fa"
                radius: 4

                Text {
                    anchors.centerIn: parent
                    text: model.day
                    font.pixelSize: 14
                    
                    // Dim the text if the day belongs to the previous or next month
                    color: model.month === grid.month 
                           ? (typeof colors !== "undefined" ? colors.foreground : "#cdd6f4") 
                           : (typeof colors !== "undefined" ? colors.color8 : "#585b70")
                }
            }
        }
    }
}
