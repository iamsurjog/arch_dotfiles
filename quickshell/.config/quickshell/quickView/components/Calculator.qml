import QtQuick
import QtQuick.Layouts

Rectangle {
    id: root
    color: typeof colors !== "undefined" ? colors.background : "#1e1e2e"
    radius: 8

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
            Layout.preferredHeight: 60
            color: "transparent"
            border.width: 1
            border.color: typeof colors !== "undefined" ? colors.color8 : "#45475a"
            radius: 6

            Text {
                anchors.fill: parent
                anchors.margins: 12
                text: root.display
                color: typeof colors !== "undefined" ? colors.foreground : "#cdd6f4"
                font.pixelSize: 24
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
                    radius: 6
                    
                    // Categorize the buttons for styling
                    property bool isOp: ["÷", "×", "-", "+", "="].includes(modelData)
                    property bool isAction: ["C", "⌫", "(", ")"].includes(modelData)
                    
                    // Button Background Color State
                    color: {
                        if (mouseArea.pressed) return typeof colors !== "undefined" ? colors.color5 : "#89b4fa"
                        if (isOp) return typeof colors !== "undefined" ? "#1Affffff" : "#1Affffff" // Slight white tint for operators
                        return "transparent"
                    }
                    
                    // Border color matches the inactive background items
                    border.width: 1
                    border.color: typeof colors !== "undefined" ? colors.color0 : "#313244"

                    Text {
                        anchors.centerIn: parent
                        text: modelData
                        
                        // Font Color State
                        color: {
                            if (mouseArea.pressed) return typeof colors !== "undefined" ? colors.background : "#1e1e2e" // Dark text on click
                            if (isOp || isAction) return typeof colors !== "undefined" ? colors.color5 : "#89b4fa" // Highlight color for operators
                            return typeof colors !== "undefined" ? colors.foreground : "#cdd6f4" // Standard text for numbers
                        }
                        
                        font.pixelSize: 18
                        font.bold: true
                    }

                    MouseArea {
                        id: mouseArea
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: handleInput(modelData)
                    }
                }
            }
        }
    }
}
