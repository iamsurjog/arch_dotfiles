import QtQuick
import QtQuick.Layouts
import Quickshell.Io // Required for the Process component

Rectangle {
    id: ramCard
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
    property var ramHistory: []
    property int maxPoints: 30
    property real currentRam: 0

    // Fetch memory usage
    Process {
        id: ramProcess
        command: ["sh", "-c", "free | awk '/^Mem:/ {print $3/$2}'"]
        running: true
        stdout: StdioCollector {
            onStreamFinished: {
                let val = parseFloat(this.text.trim())
                if (!isNaN(val)) {
                    ramCard.currentRam = val
                    let hist = ramCard.ramHistory
                    hist.push(val)
                    if (hist.length > ramCard.maxPoints) {
                        hist.shift()
                    }
                    ramCard.ramHistory = hist
                    ramCanvas.requestPaint()
                }
            }
        }
    }

    Timer {
        interval: 2000
        running: true
        repeat: true
        onTriggered: ramProcess.running = true
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
                text: "MEMORY"
                color: theme.text
                font.pixelSize: 15
                font.bold: true
                font.letterSpacing: 1
            }

            Item { Layout.fillWidth: true } // Spacer

            Text {
                text: Math.round(ramCard.currentRam * 100) + "%"
                color: colors.color9
                font.pixelSize: 16
                font.bold: true
            }
        }

        // Graph Area
        Item {
            Layout.fillWidth: true
            Layout.fillHeight: true

            Canvas {
                id: ramCanvas
                anchors.fill: parent
                // Graph redraws automatically when the layout resizes
                onWidthChanged: requestPaint()
                onHeightChanged: requestPaint()

                onPaint: {
                    var ctx = getContext("2d")
                    ctx.clearRect(0, 0, width, height)

                    let hist = ramCard.ramHistory
                    if (hist.length < 2) return

                    var w = width
                    var h = height
                    var step = w / (ramCard.maxPoints - 1)

                    // 1. Filled gradient background
                    ctx.beginPath()
                    ctx.moveTo(0, h)
                    for (var i = 0; i < hist.length; i++) {
                        // Leave a tiny bit of padding at the top so 100% doesn't hit the text
                        var yFill = h - (hist[i] * (h * 0.9))
                        ctx.lineTo(i * step, yFill)
                    }
                    ctx.lineTo((hist.length - 1) * step, h)
                    ctx.closePath()
                    
                    ctx.fillStyle = theme.fade(colors.color9, 0.15).toString()
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
                    ctx.strokeStyle = colors.color9.toString()
                    ctx.stroke()
                }
            }
        }
    }
}
