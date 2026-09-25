import QtQuick
import QtQuick.Layouts
import Quickshell.Services.Notifications as Notifs

Rectangle {
    id: root
    color: typeof colors !== "undefined" ? colors.background : "#1e1e2e"
    radius: 8

    // This acts as the actual system notification daemon
    Notifs.NotificationServer {
        id: server
        
        // Tell apps to send us the good stuff
        bodySupported: true
        actionsSupported: true
        imageSupported: true
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 16
        spacing: 12

        // Header
        RowLayout {
            Layout.fillWidth: true
            
            Text {
                text: "Notifications"
                color: typeof colors !== "undefined" ? colors.color5 : "#89b4fa"
                font.pixelSize: 20
                font.bold: true
                Layout.fillWidth: true
            }
        }

        // The Scrollable Notification List
        ListView {
            id: listView
            Layout.fillWidth: true
            Layout.fillHeight: true
            clip: true
            spacing: 8
            
            // Quickshell's server provides a reactive ObjectModel out of the box
            model: server.trackedNotifications
            
            // Empty State
            Text {
                anchors.centerIn: parent
                visible: listView.count === 0
                text: "All caught up"
                color: typeof colors !== "undefined" ? colors.color8 : "#585b70"
                font.pixelSize: 14
                font.italic: true
            }

            delegate: Rectangle {
                width: ListView.view.width
                implicitHeight: contentRow.implicitHeight + 16
                color: "transparent"
                border.width: 1
                border.color: typeof colors !== "undefined" ? colors.color0 : "#313244"
                radius: 6
                
                // Grab the current notification object from the model
                property var notif: modelData

                RowLayout {
                    id: contentRow
                    anchors.fill: parent
                    anchors.margins: 10
                    spacing: 12

                    // Accent bar on the left
                    Rectangle {
                        Layout.preferredWidth: 4
                        Layout.fillHeight: true
                        color: typeof colors !== "undefined" ? colors.color5 : "#89b4fa"
                        radius: 2
                    }

                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 4
                        
                        RowLayout {
                            Layout.fillWidth: true
                            
                            // App Name
                            Text {
                                text: notif.appName !== "" ? notif.appName : "System"
                                color: typeof colors !== "undefined" ? colors.color5 : "#89b4fa"
                                font.pixelSize: 12
                                font.bold: true
                                Layout.fillWidth: true
                            }
                            
                            // Dismiss Button ("X")
                            Text {
                                text: "✕"
                                color: typeof colors !== "undefined" ? colors.color8 : "#7f849c"
                                font.pixelSize: 14
                                
                                MouseArea {
                                    anchors.fill: parent
                                    anchors.margins: -5 // Larger hit area
                                    cursorShape: Qt.PointingHandCursor
                                    
                                    // Using Quickshell's built-in dismiss function to clear it
                                    onClicked: notif.dismiss()
                                }
                            }
                        }

                        // Notification Summary (Title)
                        Text {
                            text: notif.summary || "Notification"
                            color: typeof colors !== "undefined" ? colors.foreground : "#cdd6f4"
                            font.pixelSize: 14
                            font.bold: true
                            elide: Text.ElideRight
                            Layout.fillWidth: true
                        }

                        // Notification Body
                        Text {
                            text: notif.body || ""
                            color: typeof colors !== "undefined" ? colors.color8 : "#a6adc8"
                            font.pixelSize: 12
                            wrapMode: Text.Wrap
                            maximumLineCount: 3 // Keeps long notifications from blowing up your layout
                            elide: Text.ElideRight
                            Layout.fillWidth: true
                            visible: text !== "" // Hide entirely if there is no body
                        }
                    }
                }
            }
        }
    }
}
