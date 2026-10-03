import QtQuick
import QtQuick.Layouts
import Quickshell.Io

Rectangle {
    id: root
    width: 350
    height: 500
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

    // --- TODOS ADAPTER ---
    FileView {
        path: "/home/randomguy/surjo/apps/timeBox/todos.json"
        watchChanges: true
        onFileChanged: reload()

        JsonAdapter {
            id: todosAdapter
            property var events: []

            onEventsChanged: {
                todosModel.clear()
                if (!events) return;
                
                // Calculate the cutoff date (3 days / 72 hours from right now)
                let now = new Date();
                let cutoffDate = new Date(now.getTime() + (3 * 24 * 60 * 60 * 1000));
                
                for (let i = 0; i < events.length; i++) {
                    let ev = events[i];
                    let title = ev.summary || "(No title)";
                    
                    // Determine if it's an all-day event or has a specific time
                    let isAllDay = !ev.start.dateTime; 
                    let rawDate = ev.start.dateTime || ev.start.date || "";
                    
                    if (!rawDate) continue; 
                    
                    let eventDate = new Date(rawDate);
                    
                    // SKIP this event if it is further out than 3 days
                    if (eventDate > cutoffDate) {
                        continue; 
                    }
                    
                    // Build the display string
                    let displayDate = eventDate.toDateString(); 
                    
                    // If it's not an all-day event, append the local time
                    if (!isAllDay) {
                        // Locale.ShortFormat gives a clean "HH:MM AM/PM" based on system settings
                        let timeString = eventDate.toLocaleTimeString(Qt.locale(), Locale.ShortFormat);
                        displayDate += " at " + timeString;
                    } else {
                        displayDate += " (All day)";
                    }
                    
                    todosModel.append({
                        "title": title,
                        "dateString": displayDate
                    });
                }
            }
        }
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 16
        spacing: 12

        // --- HEADER ---
        RowLayout {
            Layout.fillWidth: true
            spacing: 10

            // Accent tick
            Rectangle {
                Layout.preferredWidth: 4
                Layout.preferredHeight: 20
                radius: 2
                color: theme.accent
            }

            Text {
                text: "Upcoming Todos"
                font.pixelSize: 20
                font.bold: true
                font.letterSpacing: 0.4
                color: theme.text
                Layout.fillWidth: true
            }
        }

        Rectangle {
            Layout.fillWidth: true
            height: 1
            color: theme.line
        }

        // --- EVENT LIST ---
        ListView {
            id: todoList
            Layout.fillWidth: true
            Layout.fillHeight: true
            clip: true
            spacing: 10

            model: ListModel { id: todosModel }

            delegate: Rectangle {
                width: ListView.view.width
                height: 65
                radius: 12
                clip: true
                color: theme.raised
                border.width: 1
                border.color: theme.lineSoft

                Behavior on color {
                    ColorAnimation {
                        duration: 140
                    }
                }

                // Accent bar marks the card down the left edge
                Rectangle {
                    anchors {
                        left: parent.left
                        top: parent.top
                        bottom: parent.bottom
                    }
                    width: 4
                    color: theme.accent
                    opacity: 0.9
                }

                ColumnLayout {
                    anchors.fill: parent
                    anchors.leftMargin: 18
                    anchors.rightMargin: 12
                    anchors.topMargin: 10
                    anchors.bottomMargin: 10
                    spacing: 4

                    Text {
                        text: model.title
                        font.pixelSize: 16
                        font.bold: true
                        color: theme.text
                        Layout.fillWidth: true
                        elide: Text.ElideRight
                    }

                    Text {
                        text: model.dateString
                        font.pixelSize: 13
                        color: theme.textDim
                        Layout.fillWidth: true
                        elide: Text.ElideRight
                    }
                }
            }
        }

    }

    // Shown while nothing is coming up
    Text {
        anchors.centerIn: parent
        anchors.verticalCenterOffset: 30
        horizontalAlignment: Text.AlignHCenter
        text: "Nothing scheduled\nall clear for the next 3 days"
        color: theme.textMute
        font.pixelSize: 15
        lineHeight: 1.4
        visible: todosModel.count === 0
    }
}
