import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

Rectangle {
    id: root
    radius: 16
    clip: true
    color: "transparent"
    gradient: Gradient {
        GradientStop {
            position: 0.0
            color: theme.card
        }
        GradientStop {
            position: 1.0
            color: theme.cardDeep
        }
    }
    border.width: 1
    border.color: theme.line

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
            Rectangle {
                Layout.preferredWidth: 32
                Layout.preferredHeight: 32
                radius: 10
                color: navPrev.containsMouse ? theme.fade(colors.foreground, 0.10) : "transparent"
                border.width: 1
                border.color: theme.lineSoft

                Behavior on color {
                    ColorAnimation {
                        duration: 120
                    }
                }

                Text {
                    anchors.centerIn: parent
                    text: "‹"
                    color: theme.fade(colors.cursor, 0.95)
                    font.pixelSize: 22
                    font.bold: true
                }

                MouseArea {
                    id: navPrev
                    anchors.fill: parent
                    anchors.margins: -6 // Increase hit area for easier clicking
                    hoverEnabled: true
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
                color: theme.text
                font.pixelSize: 17
                font.bold: true
                font.letterSpacing: 0.5
            }

            Item { Layout.fillWidth: true } // Spacer

            // Next Month Button
            Rectangle {
                Layout.preferredWidth: 32
                Layout.preferredHeight: 32
                radius: 10
                color: navNext.containsMouse ? theme.fade(colors.foreground, 0.10) : "transparent"
                border.width: 1
                border.color: theme.lineSoft

                Behavior on color {
                    ColorAnimation {
                        duration: 120
                    }
                }

                Text {
                    anchors.centerIn: parent
                    text: "›"
                    color: theme.fade(colors.cursor, 0.95)
                    font.pixelSize: 22
                    font.bold: true
                }

                MouseArea {
                    id: navNext
                    anchors.fill: parent
                    anchors.margins: -6
                    hoverEnabled: true
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
                color: theme.textMute
                font.pixelSize: 11
                font.bold: true
                font.letterSpacing: 1
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
                color: isToday ? theme.fade(colors.color10, 0.30) : "transparent"

                // Check if this specific grid cell represents today's real date
                property bool isToday: model.date.getDate() === root.today.getDate() &&
                                       model.date.getMonth() === root.today.getMonth() &&
                                       model.date.getFullYear() === root.today.getFullYear()

                // A soft accent tile keeps today findable without shouting
                border.width: 1
                border.color: isToday ? theme.ring : "transparent"
                radius: 9

                Behavior on color {
                    ColorAnimation {
                        duration: 160
                    }
                }

                Text {
                    anchors.centerIn: parent
                    text: model.day
                    font.pixelSize: 14
                    font.bold: isToday
                    
                    // Dim the text if the day belongs to the previous or next month
                    color: model.month === grid.month ? theme.text : theme.textMute
                }
            }
        }
    }
}
