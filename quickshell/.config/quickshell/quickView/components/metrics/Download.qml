import QtQuick
import QtQuick.Layouts
import Quickshell.Io 

Rectangle {
    id: netCard
    Layout.fillWidth: true
    Layout.fillHeight: true
    Layout.preferredWidth: 1
    Layout.preferredHeight: 1
    
    // Theme styling
    radius: 16
    clip: true
    color: "transparent"
    gradient: Gradient {
        GradientStop { position: 0.0; color: theme.card }
        GradientStop { position: 1.0; color: theme.cardDeep }
    }
    border.width: 1
    border.color: theme.line

    // State properties
    property var netHistory: []
    property int maxPoints: 30
    property double maxSpeed: 1024 
    property double lastRx: -1
    property double currentSpeed: 0

    function formatBytes(bytes) {
        if (bytes === 0 || isNaN(bytes)) return "0 B/s"
        const k = 1024
        const sizes = ['B/s', 'KB/s', 'MB/s', 'GB/s']
        const i = Math.floor(Math.log(bytes) / Math.log(k))
        return parseFloat((bytes / Math.pow(k, i)).toFixed(1)) + ' ' + sizes[i]
    }

    // Stress Test Process
    Process {
        id: testProcess
        command: ["sh", "-c", "curl -o /dev/null https://cachefly.cachefly.net/300mb.test"]
        running: false // Starts stopped
    }

    // Network tracking process
    Process {
        id: netProcess
        command: ["sh", "-c", "awk 'NR>2 && $1 !~ /^lo:/ {rx+=$2} END {print rx}' /proc/net/dev"]
        running: true
        stdout: StdioCollector {
            onStreamFinished: {
                let currentRx = parseFloat(this.text.trim())
                if (!isNaN(currentRx)) {
                    if (netCard.lastRx !== -1) {
                        let speed = currentRx - netCard.lastRx
                        netCard.currentSpeed = speed
                        
                        if (speed > netCard.maxSpeed) {
                            netCard.maxSpeed = speed 
                        } else {
                            netCard.maxSpeed = netCard.maxSpeed * 0.95 
                        }
                        
                        if (netCard.maxSpeed < 1024) netCard.maxSpeed = 1024

                        let hist = netCard.netHistory
                        hist.push(speed)
                        if (hist.length > netCard.maxPoints) {
                            hist.shift()
                        }
                        netCard.netHistory = hist
                        netCanvas.requestPaint()
                    }
                    netCard.lastRx = currentRx
                }
            }
        }
    }

    Timer {
        interval: 1000 
        running: true
        repeat: true
        onTriggered: netProcess.running = true
    }

    ColumnLayout {
        anchors.fill: parent
        spacing: 0

        // Header
        RowLayout {
            Layout.fillWidth: true
            Layout.margins: 16
            Layout.bottomMargin: 8

            Text {
                text: "NETWORK (RX)"
                color: theme.text
                font.pixelSize: 15
                font.bold: true
                font.letterSpacing: 1
            }

            Item { Layout.fillWidth: true }

            Text {
                text: netCard.formatBytes(netCard.currentSpeed)
                color: colors.color11
                font.pixelSize: 16
                font.bold: true
            }

            // Play/Stop Stress Test Button
            Rectangle {
                Layout.preferredWidth: 26
                Layout.preferredHeight: 26
                Layout.leftMargin: 8
                radius: 6
                color: testBtnArea.containsMouse ? theme.fade(colors.color11, 0.2) : (testProcess.running ? theme.fade(colors.color11, 0.1) : "transparent")
                border.width: 1
                border.color: testProcess.running ? colors.color11 : theme.fade(theme.line, 0.5)

                Behavior on color { ColorAnimation { duration: 150 } }

                Text {
                    anchors.centerIn: parent
                    // Show a square (stop) if running, a triangle (play) if not
                    text: testProcess.running ? "■" : "▶"
                    color: testProcess.running ? colors.color11 : theme.text
                    font.pixelSize: 12
                }

                MouseArea {
                    id: testBtnArea
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onClicked: {
                        // Toggling running to false sends a SIGTERM, immediately killing curl
                        testProcess.running = !testProcess.running
                    }
                }
            }
        }

        // Graph Area
        Item {
            Layout.fillWidth: true
            Layout.fillHeight: true

            Canvas {
                id: netCanvas
                anchors.fill: parent
                onWidthChanged: requestPaint()
                onHeightChanged: requestPaint()

                onPaint: {
                    var ctx = getContext("2d")
                    ctx.clearRect(0, 0, width, height)

                    let hist = netCard.netHistory
                    if (hist.length < 2) return

                    var w = width
                    var h = height
                    var step = w / (netCard.maxPoints - 1)

                    ctx.beginPath()
                    ctx.moveTo(0, h)
                    for (var i = 0; i < hist.length; i++) {
                        var yFill = h - ((hist[i] / netCard.maxSpeed) * (h * 0.9))
                        ctx.lineTo(i * step, Math.max(0, yFill)) 
                    }
                    ctx.lineTo((hist.length - 1) * step, h)
                    ctx.closePath()
                    
                    ctx.fillStyle = theme.fade(colors.color11, 0.15).toString()
                    ctx.fill()

                    ctx.beginPath()
                    for (var j = 0; j < hist.length; j++) {
                        var x = j * step
                        var yLine = h - ((hist[j] / netCard.maxSpeed) * (h * 0.9))
                        if (j === 0) ctx.moveTo(x, Math.max(0, yLine))
                        else ctx.lineTo(x, Math.max(0, yLine))
                    }
                    
                    ctx.lineWidth = 2
                    ctx.strokeStyle = colors.color11.toString()
                    ctx.stroke()
                }
            }
        }
    }
}
