import QtQuick
import QtQuick.Layouts
import Quickshell.Io 

Rectangle {
    id: gpu1Card
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

    property var gpuHistory: []
    property int maxPoints: 30
    property real currentGpu: 0

    // Targets index 1 for nvidia-smi, or card1 for AMD sysfs
    Process {
        id: gpu1Process
        command: ["sh", "-c", "nvidia-smi -i 1 --query-gpu=utilization.gpu --format=csv,noheader,nounits 2>/dev/null || cat /sys/class/drm/card1/device/gpu_busy_percent 2>/dev/null || echo 0"]
        running: true
        stdout: StdioCollector {
            onStreamFinished: {
                let val = parseFloat(this.text.trim())
                if (!isNaN(val)) {
                    gpu1Card.currentGpu = val
                    let hist = gpu1Card.gpuHistory
                    hist.push(val)
                    if (hist.length > gpu1Card.maxPoints) {
                        hist.shift()
                    }
                    gpu1Card.gpuHistory = hist
                    gpu1Canvas.requestPaint()
                }
            }
        }
    }

    Timer {
        interval: 1000 
        running: true
        repeat: true
        onTriggered: gpu1Process.running = true
    }

    ColumnLayout {
        anchors.fill: parent
        spacing: 0

        RowLayout {
            Layout.fillWidth: true
            Layout.margins: 16
            Layout.bottomMargin: 8

            Text {
                text: "Internal GPU"
                color: theme.text
                font.pixelSize: 15
                font.bold: true
                font.letterSpacing: 1
            }

            Item { Layout.fillWidth: true }

            Text {
                text: Math.round(gpu1Card.currentGpu) + "%"
                color: colors.color14
                font.pixelSize: 16
                font.bold: true
            }
        }

        Item {
            Layout.fillWidth: true
            Layout.fillHeight: true

            Canvas {
                id: gpu1Canvas
                anchors.fill: parent
                onWidthChanged: requestPaint()
                onHeightChanged: requestPaint()

                onPaint: {
                    var ctx = getContext("2d")
                    ctx.clearRect(0, 0, width, height)

                    let hist = gpu1Card.gpuHistory
                    if (hist.length < 2) return

                    var w = width
                    var h = height
                    var step = w / (gpu1Card.maxPoints - 1)

                    ctx.beginPath()
                    ctx.moveTo(0, h)
                    for (var i = 0; i < hist.length; i++) {
                        var yFill = h - ((hist[i] / 100) * (h * 0.9))
                        ctx.lineTo(i * step, yFill)
                    }
                    ctx.lineTo((hist.length - 1) * step, h)
                    ctx.closePath()
                    
                    ctx.fillStyle = theme.fade(colors.color14, 0.15).toString()
                    ctx.fill()

                    ctx.beginPath()
                    for (var j = 0; j < hist.length; j++) {
                        var x = j * step
                        var yLine = h - ((hist[j] / 100) * (h * 0.9))
                        if (j === 0) ctx.moveTo(x, yLine)
                        else ctx.lineTo(x, yLine)
                    }
                    
                    ctx.lineWidth = 2
                    ctx.strokeStyle = colors.color14.toString()
                    ctx.stroke()
                }
            }
        }
    }
}
