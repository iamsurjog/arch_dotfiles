import QtQuick
import QtQuick.Layouts

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

    // Internal state for math evaluation
    property string expression: ""
    property string display: "0"

    function calculate() {
        try {
            // Convert UI symbols to standard JavaScript math operators
            let toEval = expression.replace(/×/g, "*").replace(/÷/g, "/")
            
            // Basic security check: only evaluate if it contains valid math characters
            if (/[^0-9\.\+\-\*\/\(\)]/.test(toEval)) return
            if (toEval === "") return
            
            let result = eval(toEval)
            
            // Round to 8 decimal places to avoid floating point anomalies (e.g. 0.1 + 0.2 = 0.30000000000000004)
            display = Math.round(result * 100000000) / 100000000
            
            // Store the result back into the expression so the user can chain calculations
            expression = display.toString()
        } catch (e) {
            display = "Error"
            expression = ""
        }
    }

    function handleInput(key) {
        if (display === "Error") {
            display = "0"
            expression = ""
        }

        if (key === "C") {
            expression = ""
            display = "0"
        } else if (key === "⌫") {
            expression = expression.slice(0, -1)
            display = expression === "" ? "0" : expression
        } else if (key === "=") {
            calculate()
        } else {
            // Replace the initial "0" unless they are typing a decimal
            if (expression === "0" && key !== ".") expression = ""
            expression += key
            display = expression
        }
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 16
        spacing: 12

        // Top Display Screen
        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 62
            radius: 12
            color: theme.fade(colors.foreground, 0.05)
            border.width: 1
            border.color: theme.line

            Text {
                anchors.fill: parent
                anchors.margins: 14
                text: root.display
                color: theme.text
                font.pixelSize: 26
                font.bold: true
                horizontalAlignment: Text.AlignRight
                verticalAlignment: Text.AlignVCenter
                clip: true // Prevents massive numbers from spilling out of the box
            }
        }

        // 4x5 Keypad Grid
        GridLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            columns: 4
            columnSpacing: 8
            rowSpacing: 8

            Repeater {
                model: [
                    "C", "(", ")", "÷",
                    "7", "8", "9", "×",
                    "4", "5", "6", "-",
                    "1", "2", "3", "+",
                    "0", ".", "⌫", "="
                ]

                Rectangle {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    radius: 12

                    // Categorize the buttons for styling
                    property bool isOp: ["÷", "×", "-", "+", "="].includes(modelData)
                    property bool isAction: ["C", "⌫", "(", ")"].includes(modelData)

                    // Button Background Color State
                    color: {
                        if (mouseArea.pressed) return theme.accent
                        if (mouseArea.containsMouse) return theme.fade(colors.foreground, 0.10)
                        if (isOp) return theme.fade(colors.color10, 0.16)
                        if (isAction) return theme.fade(colors.foreground, 0.045)
                        return "transparent"
                    }

                    // Border color matches the inactive background items
                    border.width: 1
                    border.color: {
                        if (mouseArea.pressed) return theme.fade(colors.color10, 0.9)
                        if (isOp) return theme.fade(colors.color10, 0.35)
                        if (mouseArea.containsMouse) return theme.line
                        return theme.lineSoft
                    }

                    Behavior on color {
                        ColorAnimation {
                            duration: 110
                        }
                    }
                    Behavior on border.color {
                        ColorAnimation {
                            duration: 110
                        }
                    }

                    Text {
                        anchors.centerIn: parent
                        text: modelData
                        
                        // Font Color State
                        color: {
                            if (mouseArea.pressed) return colors.background // Dark text on click
                            if (isOp) return theme.fade(colors.cursor, 1) // Warm accent for operators
                            if (isAction) return theme.textDim
                            return theme.text // Standard text for numbers
                        }
                        
                        font.pixelSize: 18
                        font.bold: true
                    }

                    MouseArea {
                        id: mouseArea
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: handleInput(modelData)
                    }
                }
            }
        }
    }
}
