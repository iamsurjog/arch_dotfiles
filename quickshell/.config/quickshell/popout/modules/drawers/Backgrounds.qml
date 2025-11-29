import qs.services
import qs.config
import qs.modules.dashboard as Dashboard
import QtQuick
import QtQuick.Shapes

Shape {
    id: root

    required property Panels panels

    anchors.fill: parent
    anchors.margins: Config.border.thickness
    anchors.leftMargin: 0
    preferredRendererType: Shape.CurveRenderer
    opacity: Colours.transparency.enabled ? Colours.transparency.base : 1

    Dashboard.Background {
        wrapper: panels.dashboard

        startX: (root.width - wrapper.width) / 2 - rounding
        startY: visibilities.dashboard? -20:-30
    }

}
