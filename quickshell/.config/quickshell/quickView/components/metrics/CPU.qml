import QtQuick
import QtQuick.Layouts
import Quickshell.Io 

Rectangle {
    id: cpuCard
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
    property var cpuHistory: []
    property int maxPoints: 30
    property real currentCpu: 0
    property real lastTotal: -1
    property real lastIdle: -1

    // Fetch total CPU cycles and idle cycles
    Process {
        id: cpuProcess
        command: ["sh", "-c", "awk '/^cpu / {total=0; for(i=2;i<=NF;i++) total+=$i; print total, $5}' /proc/stat"]
        running: true
        stdout: StdioCollector {
            onStreamFinished: {
                let parts = this.text.trim().split(" ")
                if (parts.length === 2) {
                    let total = parseFloat(parts[0])
                    let idle = parseFloat(parts[1])
                    
                    if (cpuCard.lastTotal !== -1) {
                        let deltaTotal = total - cpuCard.lastTotal
                        let deltaIdle = idle - cpuCard.lastIdle
                        let usage = 0
                        
                        // Prevent division by zero if tick was too fast
                        if (deltaTotal > 0) {
                            usage = (deltaTotal - deltaIdle) / deltaTotal
                        }
                        
                        cpuCard.currentCpu = usage
                        let hist = cpuCard.cpuHistory
                        hist.push(usage)
                        if (hist.length > cpuCard.maxPoints) {
                            hist.shift()
                        }
                        cpuCard.cpuHistory = hist
                        cpuCanvas.requestPaint()
                    }
                    cpuCard.lastTotal = total
                    cpuCard.lastIdle = idle
                }
            }
        }
    }

    Timer {
        interval: 1000 // 1-second intervals are standard for CPU tracking
        running: true
        repeat: true
        onTriggered: cpuProcess.running = true
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
                text: "PROCESSOR"
                color: theme.text
                font.pixelSize: 15
                font.bold: true
                font.letterSpacing: 1
            }

            Item { Layout.fillWidth: true }

            Text {
                text: Math.round(cpuCard.currentCpu * 100) + "%"
                color: colors.color10
                font.pixelSize: 16
                font.bold: true
            }
        }

        // Graph Area
        Item {
            Layout.fillWidth: true
            Layout.fillHeight: true

            Canvas {
                id: cpuCanvas
                anchors.fill: parent
                onWidthChanged: requestPaint()
                onHeightChanged: requestPaint()

                onPaint: {
                    var ctx = getContext("2d")
                    ctx.clearRect(0, 0, width, height)

                    let hist = cpuCard.cpuHistory
                    if (hist.length < 2) return

                    var w = width
                    var h = height
                    var step = w / (cpuCard.maxPoints - 1)

                    // 1. Filled gradient background
                    ctx.beginPath()
                    ctx.moveTo(0, h)
                    for (var i = 0; i < hist.length; i++) {
                        var yFill = h - (hist[i] * (h * 0.9))
                        ctx.lineTo(i * step, yFill)
                    }
                    ctx.lineTo((hist.length - 1) * step, h)
                    ctx.closePath()
                    
                    ctx.fillStyle = theme.fade(colors.color10, 0.15).toString()
                    ctx.fill()

                    // 2. Primary stroke line
                    ctx.beginPath()
                    for (var j = 0; j < hist.length; j++) {
                        var x = j * step
                        var yLine = h - (hist[j] * (h * 0.9))
                        if (j === 0) ctx.moveTo(x, yLine)
                        else ctx.lineTo(x, yLine)
                    }
                    
                    ctx.lineWidth = 2
                    ctx.strokeStyle = colors.color10.toString()
                    ctx.stroke()
                }
            }
        }
    }
}
