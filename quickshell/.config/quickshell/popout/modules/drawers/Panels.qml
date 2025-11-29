import qs.services
import qs.config
import qs.modules.dashboard as Dashboard
import Quickshell
import QtQuick

Item {
    id: root

    required property ShellScreen screen
    required property PersistentProperties visibilities

    readonly property Dashboard.Wrapper dashboard: dashboard

    anchors.fill: parent
    anchors.margins: Config.border.thickness
    anchors.leftMargin: 0


    Dashboard.Wrapper {
        id: dashboard

        visibilities: root.visibilities

        y: 0
        x: (parent.width - width) / 2 



        Behavior on x {
            NumberAnimation {
                duration: Appearance.anim.durations.expressiveDefaultSpatial
                easing.type: Easing.BezierSpline
                easing.bezierCurve: Appearance.anim.curves.expressiveDefaultSpatial
            }
        }
    }


}
