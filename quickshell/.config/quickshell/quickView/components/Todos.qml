import QtQuick
import QtQuick.Layouts
import Quickshell.Io

Rectangle {
    id: root
    width: 350
    height: 500
    color: colors.background
    radius: 12
    border.color: colors.color8
    border.width: 2

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
        anchors.margins: 15
        spacing: 12

        // --- HEADER ---
        Text {
            text: "Upcoming Todos"
            font.pixelSize: 22
            font.bold: true
            color: colors.color1
            Layout.fillWidth: true
        }

        Rectangle {
            Layout.fillWidth: true
            height: 1
            color: colors.color8
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
                color: colors.color0
                radius: 8

                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: 10
                    spacing: 4

                    Text {
                        text: model.title
                        font.pixelSize: 16
                        font.bold: true
                        color: colors.color4
                        Layout.fillWidth: true
                        elide: Text.ElideRight
                    }

                    Text {
                        text: model.dateString
                        font.pixelSize: 13
                        color: colors.color7
                        Layout.fillWidth: true
                    }
                }
            }
        }
    }
}
