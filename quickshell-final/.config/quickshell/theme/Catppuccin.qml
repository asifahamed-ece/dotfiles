pragma Singleton
import QtQuick

QtObject {
    // Catppuccin Mocha Palette - Exact hex codes from ShadowArch theme
    readonly property color base: "#1e1e2e"
    readonly property color mantle: "#181825"
    readonly property color crust: "#11111b"
    
    // Text colors
    readonly property color text: "#cdd6f4"
    readonly property color subtext0: "#a6adc8"
    readonly property color subtext1: "#bac2de"
    
    // Surface colors (for modules, panels)
    readonly property color surface0: "#313244"
    readonly property color surface1: "#45475a"
    readonly property color surface2: "#585b70"
    
    // Overlay colors
    readonly property color overlay0: "#6c7086"
    readonly property color overlay1: "#7f849c"
    readonly property color overlay2: "#9399b2"
    
    // Accent colors
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
    
    // Glass & UI Properties - Matching Waybar's glass effect
    readonly property color moduleBg: "rgba(255, 255, 255, 0.08)"
    readonly property color moduleBgHover: "rgba(255, 255, 255, 0.14)"
    readonly property color glassBorder: "rgba(255, 255, 255, 0.12)"
    readonly property color bgTranslucent: "rgba(15, 15, 20, 0.65)"
    
    // Bar dimensions - Matching Waybar layout
    readonly property int barHeight: 28
    readonly property int barMargin: 10
    readonly property int moduleRadius: 12
    readonly property int gapsIn: 2
    readonly property int gapsOut: 5
    
    // Animation timings (ms) - Synced with Hyprland bezier curves in hyprland.lua
    readonly property int transitionSlow: 280
    readonly property int transitionFast: 180
    
    // Bezier curve easing values for QML animations
    // Matches easeOutExpo from hyprland.lua
    readonly property real easeOutExpoEasing: 0.16
}
