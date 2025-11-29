pragma Singleton

import qs.config
import qs.utils
import Quickshell
import Quickshell.Io
import QtQuick

Singleton {
    id: root

    readonly property list<string> colourNames: ["rosewater", "flamingo", "pink", "mauve", "red", "maroon", "peach", "yellow", "green", "teal", "sky", "sapphire", "blue", "lavender"]

    property bool showPreview
    property string scheme
    property string flavour
    property bool light
    readonly property M3Palette palette: showPreview ? preview : current
    readonly property M3Palette current: M3Palette {}
    readonly property M3Palette preview: M3Palette {}
    readonly property Transparency transparency: Transparency {}

    function alpha(c: color, layer: bool): color {
        if (!transparency.enabled)
            return c;
        c = Qt.rgba(c.r, c.g, c.b, layer ? transparency.layers : transparency.base);
        if (layer)
            c.hsvValue = Math.max(0, Math.min(1, c.hslLightness + (light ? -0.2 : 0.2)));
        return c;
    }

    function on(c: color): color {
        if (c.hslLightness < 0.5)
            return Qt.hsla(c.hslHue, c.hslSaturation, 0.9, 1);
        return Qt.hsla(c.hslHue, c.hslSaturation, 0.1, 1);
    }

    function load(data: string, isPreview: bool): void {
        const colours = isPreview ? preview : current;
        const scheme = JSON.parse(data);

        if (!isPreview) {
            root.scheme = scheme.name;
            flavour = scheme.flavour;
        }

        light = scheme.mode === "light";

        for (const [name, colour] of Object.entries(scheme.colours)) {
            const propName = colourNames.includes(name) ? name : `m3${name}`;
            if (colours.hasOwnProperty(propName))
                colours[propName] = `#${colour}`;
        }
    }

    function setMode(mode: string): void {
        Quickshell.execDetached(["caelestia", "scheme", "set", "--notify", "-m", mode]);
    }

    FileView {
        path: `../scheme.json`
        watchChanges: true
        onFileChanged: reload()
        onLoaded: root.load(text(), false)
    }

    component Transparency: QtObject {
        readonly property bool enabled: false
        readonly property real base: 0.78
        readonly property real layers: 0.58
    }

    component M3Palette: QtObject {
        property color m3primary_paletteKeyColor: "#B6685F"
        property color m3secondary_paletteKeyColor: "#5E4A48"
        property color m3tertiary_paletteKeyColor: "#AB7064"
        property color m3neutral_paletteKeyColor: "#3A3939"
        property color m3neutral_variant_paletteKeyColor: "#A79994"

        property color m3background: "#0F0E0E"
        property color m3onBackground: "#F9EBE7"
        property color m3surface: "#0F0E0E"
        property color m3surfaceDim: "#0F0E0E"
        property color m3surfaceBright: "#3A3939"
        property color m3surfaceContainerLowest: "#0F0E0E"
        property color m3surfaceContainerLow: "#3A3939"
        property color m3surfaceContainer: "#3A3939"
        property color m3surfaceContainerHigh: "#A79994"
        property color m3surfaceContainerHighest: "#EFDAD4"
        property color m3onSurface: "#F9EBE7"

        property color m3surfaceVariant: "#5E4A48"
        property color m3onSurfaceVariant: "#EFDAD4"
        property color m3inverseSurface: "#F9EBE7"
        property color m3inverseOnSurface: "#0F0E0E"

        property color m3outline: "#A79994"
        property color m3outlineVariant: "#3A3939"

        property color m3shadow: "#000000"
        property color m3scrim: "#000000"

        property color m3surfaceTint: "#EFC6B9"
        property color m3primary: "#EFC6B9"
        property color m3onPrimary: "#0F0E0E"
        property color m3primaryContainer: "#B6685F"
        property color m3onPrimaryContainer: "#F9EBE7"
        property color m3inversePrimary: "#975D56"

        property color m3secondary: "#B6685F"
        property color m3onSecondary: "#0F0E0E"
        property color m3secondaryContainer: "#5E4A48"
        property color m3onSecondaryContainer: "#F9EBE7"

        property color m3tertiary: "#AB7064"
        property color m3onTertiary: "#0F0E0E"
        property color m3tertiaryContainer: "#895650"
        property color m3onTertiaryContainer: "#F9EBE7"

        property color m3error: "#464341"
        property color m3onError: "#F9EBE7"
        property color m3errorContainer: "#4A4644"
        property color m3onErrorContainer: "#F9EBE7"

        property color m3primaryFixed: "#EFDAD4"
        property color m3primaryFixedDim: "#EFC6B9"
        property color m3onPrimaryFixed: "#0F0E0E"
        property color m3onPrimaryFixedVariant: "#B6685F"

        property color m3secondaryFixed: "#EFDAD4"
        property color m3secondaryFixedDim: "#B6685F"
        property color m3onSecondaryFixed: "#0F0E0E"
        property color m3onSecondaryFixedVariant: "#5E4A48"

        property color m3tertiaryFixed: "#EFDAD4"
        property color m3tertiaryFixedDim: "#AB7064"
        property color m3onTertiaryFixed: "#0F0E0E"
        property color m3onTertiaryFixedVariant: "#895650"

        property color rosewater: "#EFDAD4"
        property color flamingo: "#CA6B57"
        property color pink: "#895650"
        property color mauve: "#B6685F"
        property color red: "#464341"
        property color maroon: "#4A4644"
        property color peach: "#EFC6B9"
        property color yellow: "#EFDAD4"
        property color green: "#554645"
        property color teal: "#5E4A48"
        property color sky: "#975D56"
        property color sapphire: "#B6685F"
        property color blue: "#975D56"
        property color lavender: "#AB7064"
    }
}
