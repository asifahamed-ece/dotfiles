pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Services

QtObject {
    // Catppuccin Mocha Palette
    readonly property color base: "#1e1e2e"
    readonly property color mantle: "#181825"
    readonly property color crust: "#11111b"
    readonly property color text: "#cdd6f4"
    readonly property color subtext0: "#a6adc8"
    readonly property color subtext1: "#bac2de"
    readonly property color surface0: "#313244"
    readonly property color surface1: "#45475a"
    readonly property color surface2: "#585b70"
    readonly property color overlay0: "#6c7086"
    readonly property color overlay1: "#7f849c"
    readonly property color overlay2: "#9399b2"
    readonly property color blue: "#89b4fa"
    readonly property color lavender: "#b4befe"
    readonly property color sapphire: "#74c7ec"
    readonly property color sky: "#89dceb"
    readonly property color teal: "#94e2d5"
    readonly property color green: "#a6e3a1"
    readonly property color yellow: "#f9e2af"
    readonly property color peach: "#fab387"
    readonly property color maroon: "#eba0ac"
    readonly property color red: "#f38ba8"
    readonly property color mauve: "#cba6f7"
    readonly property color pink: "#f5c2e7"
    readonly property color flamingo: "#f2cdcd"
    readonly property color rosewater: "#f5e0dc"

    // Glass & UI Properties
    readonly property color moduleBg: "rgba(255, 255, 255, 0.08)"
    readonly property color moduleBgHover: "rgba(255, 255, 255, 0.14)"
    readonly property color glassBorder: "rgba(255, 255, 255, 0.12)"
    readonly property color bgTranslucent: "rgba(15, 15, 20, 0.65)"
    
    readonly property int barHeight: 24
    readonly property int barMargin: 12
    readonly property int moduleRadius: 12
    readonly property int gapsIn: 2
    readonly property int gapsOut: 5
    
    // Animation timings (ms) - synced with Hyprland bezier curves
    readonly property int transitionSlow: 280
    readonly property int transitionFast: 180
    
    // Bezier curve approximation for QML animations
    // easeOutQuint equivalent
    readonly property real easeOutQuintEasing: 0.23
}
