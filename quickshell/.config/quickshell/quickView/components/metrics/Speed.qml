import QtQuick
import QtQuick.Layouts
import Quickshell.Io 

Rectangle {
    id: stressTestCard
    Layout.fillWidth: true
    Layout.fillHeight: true
    Layout.preferredWidth: 1
    Layout.preferredHeight: 1
    
    radius: 16
    clip: true
    color: "transparent"
    gradient: Gradient {
        GradientStop { position: 0.0; color: theme.card }
        GradientStop { position: 1.0; color: theme.cardDeep }
    }
    border.width: 1
    border.color: theme.line

    property bool isTesting: testProcess.running

    // Silently downloads ~200MB from Cloudflare to saturate the downstream connection
    Process {
        id: testProcess
        command: ["sh", "-c", "curl -o /dev/null -s 'https://cachefly.cachefly.net/300mb.test'"]
    }

    // Interactive hover overlay
    Rectangle {
        anchors.fill: parent
        radius: 16
        color: mouseArea.containsMouse ? theme.fade(colors.color11, 0.1) : "transparent"
        
        Behavior on color { 
            ColorAnimation { duration: 150 } 
        }
    }

    ColumnLayout {
        anchors.centerIn: parent
        spacing: 12

        // Spinner/Icon
        Text {
            Layout.alignment: Qt.AlignHCenter
            text: stressTestCard.isTesting ? "⟳" : "▶"
            font.pixelSize: 28
            color: stressTestCard.isTesting ? colors.color11 : theme.text
            
            RotationAnimator on rotation {
                running: stressTestCard.isTesting
                from: 0
                to: 360
                duration: 1000
                loops: Animation.Infinite
            }
        }

        // Label
        Text {
            Layout.alignment: Qt.AlignHCenter
            text: stressTestCard.isTesting ? "DOWNLOADING 300MB..." : "STRESS TEST NETWORK"
            font.pixelSize: 14
            font.bold: true
            font.letterSpacing: 1
            color: stressTestCard.isTesting ? colors.color11 : theme.text
        }
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: {
            if (!stressTestCard.isTesting) {
                testProcess.running = true
            }
        }
    }
}
