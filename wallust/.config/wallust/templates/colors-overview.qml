pragma Singleton
pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import "functions"
import "." as Common

Singleton {
    id: root
    property QtObject m3colors: Common.Config.options.appearance.useMatugenColors && matugenLoader.item 
                                 ? matugenLoader.item 
                                 : defaultColors
    property QtObject animation
    property QtObject animationCurves
    property QtObject colors
    property QtObject rounding
    property QtObject font
    property QtObject sizes

    Loader {
        id: matugenLoader
        active: Common.Config.options.appearance.useMatugenColors
        source: "Appearance.colors.qml"
    }

    property QtObject defaultColors: QtObject {
        property bool darkmode: true

        property color m3primary: "{{ color13 }}"
        property color m3onPrimary: "{{ background }}"
        property color m3primaryContainer: "{{ color1 }}"
        property color m3onPrimaryContainer: "{{ foreground }}"
        property color m3secondary: "{{ color11 }}"
        property color m3onSecondary: "{{ background }}"
        property color m3secondaryContainer: "{{ color1 }}"
        property color m3onSecondaryContainer: "{{ foreground }}"
        property color m3background: "{{ background }}"
        property color m3onBackground: "{{ foreground }}"
        property color m3surface: "{{ background }}"
        property color m3surfaceContainerLow: "{{ color0 }}"
        property color m3surfaceContainer: "{{ color0 }}"
        property color m3surfaceContainerHigh: "{{ color8 }}"
        property color m3surfaceContainerHighest: "{{ color7 }}"
        property color m3onSurface: "{{ foreground }}"
        property color m3surfaceVariant: "{{ color4 }}"
        property color m3onSurfaceVariant: "{{ color7 }}"
        property color m3inverseSurface: "{{ foreground }}"
        property color m3inverseOnSurface: "{{ background }}"
        property color m3outline: "{{ color8 }}"
        property color m3outlineVariant: "{{ color4 }}"
        property color m3shadow: "#000000"

    }

    colors: QtObject {
        property color colSubtext: m3colors.m3outline
        property color colLayer0: m3colors.m3background
        property color colOnLayer0: m3colors.m3onBackground
        property color colLayer0Border: ColorUtils.mix(root.m3colors.m3outlineVariant, colLayer0, 0.4)
        property color colLayer1: m3colors.m3surfaceContainerLow
        property color colOnLayer1: m3colors.m3onSurfaceVariant
        property color colOnLayer1Inactive: ColorUtils.mix(colOnLayer1, colLayer1, 0.45)
        property color colLayer1Hover: ColorUtils.mix(colLayer1, colOnLayer1, 0.92)
        property color colLayer1Active: ColorUtils.mix(colLayer1, colOnLayer1, 0.85)
        property color colLayer2: m3colors.m3surfaceContainer
        property color colOnLayer2: m3colors.m3onSurface
        property color colLayer2Hover: ColorUtils.mix(colLayer2, colOnLayer2, 0.90)
        property color colLayer2Active: ColorUtils.mix(colLayer2, colOnLayer2, 0.80)
        property color colPrimary: m3colors.m3primary
        property color colOnPrimary: m3colors.m3onPrimary
        property color colSecondary: m3colors.m3secondary
        property color colSecondaryContainer: m3colors.m3secondaryContainer
        property color colOnSecondaryContainer: m3colors.m3onSecondaryContainer
        property color colTooltip: m3colors.m3inverseSurface
        property color colOnTooltip: m3colors.m3inverseOnSurface
        property color colShadow: ColorUtils.transparentize(m3colors.m3shadow, 0.7)
        property color colOutline: m3colors.m3outline
    }

    rounding: QtObject {
        property int unsharpen: Common.Config.options.appearance.rounding.unsharpen
        property int verysmall: Common.Config.options.appearance.rounding.verysmall
        property int small: Common.Config.options.appearance.rounding.small
        property int normal: Common.Config.options.appearance.rounding.normal
        property int large: Common.Config.options.appearance.rounding.large
        property int full: Common.Config.options.appearance.rounding.full
        property int screenRounding: Common.Config.options.appearance.rounding.screenRounding
        property int windowRounding: Common.Config.options.appearance.rounding.windowRounding
    }

    font: QtObject {
        property QtObject family: QtObject {
            property string main: Common.Config.options.appearance.font.family.main
            property string title: Common.Config.options.appearance.font.family.title
            property string expressive: Common.Config.options.appearance.font.family.expressive
        }
        property QtObject pixelSize: QtObject {
            property int smaller: Common.Config.options.appearance.font.pixelSize.smaller
            property int small: Common.Config.options.appearance.font.pixelSize.small
            property int normal: Common.Config.options.appearance.font.pixelSize.normal
            property int larger: Common.Config.options.appearance.font.pixelSize.larger
            property int huge: Common.Config.options.appearance.font.pixelSize.huge
        }
    }

    animationCurves: QtObject {
        readonly property list<real> expressiveDefaultSpatial: [0.38, 1.21, 0.22, 1.00, 1, 1]
        readonly property list<real> expressiveEffects: [0.34, 0.80, 0.34, 1.00, 1, 1]
        readonly property list<real> emphasizedDecel: [0.05, 0.7, 0.1, 1, 1, 1]
        readonly property real expressiveDefaultSpatialDuration: Common.Config.options.appearance.animation.duration.elementMove
        readonly property real expressiveEffectsDuration: Common.Config.options.appearance.animation.duration.elementMoveFast
    }

    animation: QtObject {
        property QtObject elementMove: QtObject {
            property int duration: animationCurves.expressiveDefaultSpatialDuration
            property int type: Easing.BezierSpline
            property list<real> bezierCurve: animationCurves.expressiveDefaultSpatial
            property Component numberAnimation: Component {
                NumberAnimation {
                    duration: root.animation.elementMove.duration
                    easing.type: root.animation.elementMove.type
                    easing.bezierCurve: root.animation.elementMove.bezierCurve
                }
            }
        }

        property QtObject elementMoveEnter: QtObject {
            property int duration: Common.Config.options.appearance.animation.duration.elementMoveEnter
            property int type: Easing.BezierSpline
            property list<real> bezierCurve: animationCurves.emphasizedDecel
            property Component numberAnimation: Component {
                NumberAnimation {
                    duration: root.animation.elementMoveEnter.duration
                    easing.type: root.animation.elementMoveEnter.type
                    easing.bezierCurve: root.animation.elementMoveEnter.bezierCurve
                }
            }
        }

        property QtObject elementMoveFast: QtObject {
            property int duration: animationCurves.expressiveEffectsDuration
            property int type: Easing.BezierSpline
            property list<real> bezierCurve: animationCurves.expressiveEffects
            property Component numberAnimation: Component {
                NumberAnimation {
                    duration: root.animation.elementMoveFast.duration
                    easing.type: root.animation.elementMoveFast.type
                    easing.bezierCurve: root.animation.elementMoveFast.bezierCurve
                }
            }
        }
    }

    sizes: QtObject {
        property real elevationMargin: Common.Config.options.appearance.sizes.elevationMargin
    }
}

