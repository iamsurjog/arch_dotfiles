import QtQuick
import QtQuick.Layouts
import Quickshell.Io 

Rectangle {
    id: gpu0Card
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

    // Tries nvidia-smi first, falls back to AMD sysfs card0, defaults to 0
    Process {
        id: gpu0Process
        command: ["sh", "-c", "nvidia-smi -i 0 --query-gpu=utilization.gpu --format=csv,noheader,nounits 2>/dev/null || cat /sys/class/drm/card0/device/gpu_busy_percent 2>/dev/null || echo 0"]
        running: true
        stdout: StdioCollector {
            onStreamFinished: {
                let val = parseFloat(this.text.trim())
                if (!isNaN(val)) {
                    gpu0Card.currentGpu = val
                    let hist = gpu0Card.gpuHistory
                    hist.push(val)
                    if (hist.length > gpu0Card.maxPoints) {
                        hist.shift()
                    }
                    gpu0Card.gpuHistory = hist
                    gpu0Canvas.requestPaint()
                }
            }
        }
    }

    Timer {
        interval: 1000 
        running: true
        repeat: true
        onTriggered: gpu0Process.running = true
    }

    ColumnLayout {
        anchors.fill: parent
        spacing: 0

        RowLayout {
            Layout.fillWidth: true
            Layout.margins: 16
            Layout.bottomMargin: 8

            Text {
                text: "NVIDIA GPU"
                color: theme.text
                font.pixelSize: 15
                font.bold: true
                font.letterSpacing: 1
            }

            Item { Layout.fillWidth: true }

            Text {
                text: Math.round(gpu0Card.currentGpu) + "%"
                color: colors.color13
                font.pixelSize: 16
                font.bold: true
            }
        }

        Item {
            Layout.fillWidth: true
            Layout.fillHeight: true

            Canvas {
                id: gpu0Canvas
                anchors.fill: parent
                onWidthChanged: requestPaint()
                onHeightChanged: requestPaint()

                onPaint: {
                    var ctx = getContext("2d")
                    ctx.clearRect(0, 0, width, height)

                    let hist = gpu0Card.gpuHistory
                    if (hist.length < 2) return

                    var w = width
                    var h = height
                    var step = w / (gpu0Card.maxPoints - 1)

                    ctx.beginPath()
                    ctx.moveTo(0, h)
                    for (var i = 0; i < hist.length; i++) {
                        // Scale based on a fixed 100% maximum
                        var yFill = h - ((hist[i] / 100) * (h * 0.9))
                        ctx.lineTo(i * step, yFill)
                    }
                    ctx.lineTo((hist.length - 1) * step, h)
                    ctx.closePath()
                    
                    ctx.fillStyle = theme.fade(colors.color13, 0.15).toString()
                    ctx.fill()

                    ctx.beginPath()
                    for (var j = 0; j < hist.length; j++) {
                        var x = j * step
                        var yLine = h - ((hist[j] / 100) * (h * 0.9))
                        if (j === 0) ctx.moveTo(x, yLine)
                        else ctx.lineTo(x, yLine)
                    }
                    
                    ctx.lineWidth = 2
                    ctx.strokeStyle = colors.color13.toString()
                    ctx.stroke()
                }
            }
        }
    }
}
