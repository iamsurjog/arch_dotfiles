import QtQuick
import QtQuick.Layouts
import Quickshell.Io
import "metrics"

GridLayout{
    id: metrics
    columns: 2
    rows: 2
    columnSpacing: 14
    rowSpacing: 14

    RAM {
        id: ramCard
        Layout.fillWidth: true
        Layout.fillHeight: true
        Layout.preferredWidth: 1
        Layout.preferredHeight: 1
    }

    CPU {
        id: cpuCard
        Layout.fillWidth: true
        Layout.fillHeight: true
        Layout.preferredWidth: 1
        Layout.preferredHeight: 1
    }
    Rectangle {
        color: "transparent"
        Layout.fillWidth: true
        Layout.fillHeight: true
        Layout.preferredWidth: 1
        Layout.preferredHeight: 1
        GridLayout{
            id: network
            columns: 1
            rows: 2
            anchors.fill: parent

            Download {
                id: download
                Layout.fillWidth: true
                Layout.fillHeight: true
                Layout.preferredWidth: 1
                Layout.preferredHeight: 1
            }
            Upload {
                id: upload
                Layout.fillWidth: true
                Layout.fillHeight: true
                Layout.preferredWidth: 1
                Layout.preferredHeight: 1
            }



        }
    }
    Rectangle {
        color: "transparent"
        Layout.fillWidth: true
        Layout.fillHeight: true
        Layout.preferredWidth: 1
        Layout.preferredHeight: 1
        GridLayout{
            id: gpu
            columns: 1
            rows: 2
            anchors.fill: parent

            GPU0{
                id: gpu0
                Layout.fillWidth: true
                Layout.fillHeight: true
                Layout.preferredWidth: 1
                Layout.preferredHeight: 1

            }

            GPU1{
                id: gpu1
                Layout.fillWidth: true
                Layout.fillHeight: true
                Layout.preferredWidth: 1
                Layout.preferredHeight: 1

            }
        }
    }
}
