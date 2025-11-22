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
        property color m3primary_paletteKeyColor: "{{color12}}"
        property color m3secondary_paletteKeyColor: "{{color10}}"
        property color m3tertiary_paletteKeyColor: "{{color5}}"
        property color m3neutral_paletteKeyColor: "{{color0  }}"
        property color m3neutral_variant_paletteKeyColor: "{{color8}}"

        property color m3background: "{{background}}"
        property color m3onBackground: "{{foreground}}"
        property color m3surface: "{{background}}"
        property color m3surfaceDim: "{{background}}"
        property color m3surfaceBright: "{{color0}}"
        property color m3surfaceContainerLowest: "{{background}}"
        property color m3surfaceContainerLow: "{{color0}}"
        property color m3surfaceContainer: "{{color0}}"
        property color m3surfaceContainerHigh: "{{color8}}"
        property color m3surfaceContainerHighest: "{{color7}}"
        property color m3onSurface: "{{foreground}}"

        property color m3surfaceVariant: "{{color10}}"
        property color m3onSurfaceVariant: "{{color7}}"
        property color m3inverseSurface: "{{foreground}}"
        property color m3inverseOnSurface: "{{background}}"

        property color m3outline: "{{color8}}"
        property color m3outlineVariant: "{{color0}}"

        property color m3shadow: "#000000"
        property color m3scrim: "#000000"

        property color m3surfaceTint: "{{color14}}"
        property color m3primary: "{{color14}}"
        property color m3onPrimary: "{{background}}"
        property color m3primaryContainer: "{{color12}}"
        property color m3onPrimaryContainer: "{{foreground}}"
        property color m3inversePrimary: "{{color4}}"

        property color m3secondary: "{{color12}}"
        property color m3onSecondary: "{{background}}"
        property color m3secondaryContainer: "{{color10}}"
        property color m3onSecondaryContainer: "{{foreground}}"

        property color m3tertiary: "{{color5}}"
        property color m3onTertiary: "{{background}}"
        property color m3tertiaryContainer: "{{color11}}"
        property color m3onTertiaryContainer: "{{foreground}}"

        property color m3error: "{{color1}}"
        property color m3onError: "{{foreground}}"
        property color m3errorContainer: "{{color9}}"
        property color m3onErrorContainer: "{{foreground}}"

        property color m3primaryFixed: "{{color7}}"
        property color m3primaryFixedDim: "{{color14}}"
        property color m3onPrimaryFixed: "{{background}}"
        property color m3onPrimaryFixedVariant: "{{color12}}"

        property color m3secondaryFixed: "{{color7}}"
        property color m3secondaryFixedDim: "{{color12}}"
        property color m3onSecondaryFixed: "{{background}}"
        property color m3onSecondaryFixedVariant: "{{color10}}"

        property color m3tertiaryFixed: "{{color15}}"
        property color m3tertiaryFixedDim: "{{color5}}"
        property color m3onTertiaryFixed: "{{background}}"
        property color m3onTertiaryFixedVariant: "{{color11}}"

        property color rosewater: "{{color7}}"
        property color flamingo: "{{color13}}"
        property color pink: "{{color11}}"
        property color mauve: "{{color12}}"
        property color red: "{{color1}}"
        property color maroon: "{{color9}}"
        property color peach: "{{color14}}"
        property color yellow: "{{color15}}"
        property color green: "{{color2}}"
        property color teal: "{{color10}}"
        property color sky: "{{color4}}"
        property color sapphire: "{{color12}}"
        property color blue: "{{color4}}"
        property color lavender: "{{color5}}"
    }
}
