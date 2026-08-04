local mainMod = "SUPER"

require("keybindings")
require("windowrules")
		
------------------
---- MONITORS ----
------------------

-- See https://wiki.hypr.land/Configuring/Basics/Monitors/
hl.monitor({
    output   = "",
    mode     = "preferred",
    position = "auto",
    scale    = "auto",
})

-------------------
---- AUTOSTART ----
-------------------

-- See https://wiki.hypr.land/Configuring/Basics/Autostart/

-- Autostart necessary processes (like notifications daemons, status bars, etc.)
-- Or execute your favorite apps at launch like this:
--
hl.on("hyprland.start", function ()
  hl.env("XDG_CURRENT_DESKTOP", "Hyprland")

  hl.exec_cmd("sh -c 'systemctl --user import-environment WAYLAND_DISPLAY DISPLAY XDG_CURRENT_DESKTOP; systemctl --user restart --no-block cliphist-text.service cliphist-image.service'")

  hl.exec_cmd("swayosd-server &")
  hl.exec_cmd("waybar &")
  hl.exec_cmd("hyprpaper &")
  hl.exec_cmd("swaync &")

  -- hl.exec_cmd("cliphist &")
  -- hl.exec_cmd("~/.config/hypr/scripts/cliphist-daemon.sh")

  hl.exec_cmd("~/.config/hypr/scripts/nm-applet-daemon.sh")

  hl.bind(mainMod .. " + SPACE", hl.dsp.exec_cmd("rofi -show drun"))
end)

-------------------------------
---- ENVIRONMENT VARIABLES ----
-------------------------------

-- See https://wiki.hypr.land/Configuring/Advanced-and-Cool/Environment-variables/

hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_SIZE", "24")


-----------------------
----- PERMISSIONS -----
-----------------------

-- See https://wiki.hypr.land/Configuring/Advanced-and-Cool/Permissions/
-- Please note permission changes here require a Hyprland restart and are not applied on-the-fly
-- for security reasons

-- hl.config({
--   ecosystem = {
--     enforce_permissions = true,
--   },
-- })

-- hl.permission("/usr/(bin|local/bin)/grim", "screencopy", "allow")
-- hl.permission("/usr/(lib|libexec|lib64)/xdg-desktop-portal-hyprland", "screencopy", "allow")
-- hl.permission("/usr/(bin|local/bin)/hyprpm", "plugin", "allow")


-----------------------
---- LOOK AND FEEL ----
-----------------------

hl.config({
    general = {
        gaps_in  = 2,
        gaps_out = 5, -- Slightly tighter outer gaps for a cleaner look
        border_size = 2,
        col = {
            -- Catppuccin-inspired gradient border (Blue -> Pink -> Orange)
            active_border   = { colors = {"rgba(89b4faee)", "rgba(f38ba8ee)", "rgba(fab387ee)"}, angle = 135 },
            inactive_border = "rgba(313244aa)",
        },
        resize_on_border = true, -- Allows resizing by dragging borders (feels very premium)
        allow_tearing = false,
        layout = "dwindle",
    },

    decoration = {
        rounding       = 12,
        rounding_power = 2,
        active_opacity   = 0.93,
        inactive_opacity = 0.85, -- Subtle dimming for unfocused windows adds depth
        shadow = {
            enabled      = true,
            range        = 8,
            render_power = 3,
            color        = "rgba(1a1a1aee)",
        },
        blur = {
            enabled          = true,
            size             = 6,
            passes           = 3, -- More passes = smoother, higher-quality blur
            vibrancy         = 0.15,
            ignore_opacity   = true, -- Improves performance
            xray = true,        -- OPTIONAL: blur only samples the wallpaper,
                                 --    not stacked windows behind. Cleaner glass look.
        },
    },

    animations = {
        enabled = true,
    },
})

-- Default curves and animations, see https://wiki.hypr.land/Configuring/Advanced-and-Cool/Animations/
hl.curve("easeOutQuint",   { type = "bezier", points = { {0.23, 1},    {0.32, 1}    } })
hl.curve("easeInOutCubic", { type = "bezier", points = { {0.65, 0.05}, {0.36, 1}    } })
hl.curve("linear",         { type = "bezier", points = { {0, 0},       {1, 1}       } })
hl.curve("almostLinear",   { type = "bezier", points = { {0.5, 0.5},   {0.75, 1}    } })
hl.curve("quick",          { type = "bezier", points = { {0.15, 0},    {0.1, 1}     } })

-- Default springs
hl.curve("easy",           { type = "spring", mass = 1, stiffness = 238.1191, dampening = 24.21279333 })

-- Snappier, smoother curves
hl.curve("easeOutExpo",    { type = "bezier", points = { {0.16, 1}, {0.3, 1} } })
hl.curve("easeInOutCubic", { type = "bezier", points = { {0.65, 0.05}, {0.36, 1} } })
hl.curve("linear",         { type = "bezier", points = { {0, 0}, {1, 1} } })
hl.curve("overshoot",      { type = "bezier", points = { {0.35, 1.1}, {0.65, 1.1} } }) -- Subtle, elegant bounce

hl.animation({ leaf = "global",        enabled = true, speed = 3.5, bezier = "easeOutExpo" })
hl.animation({ leaf = "border",        enabled = true, speed = 4.0, bezier = "easeOutExpo" })
hl.animation({ leaf = "windows",       enabled = true, speed = 3.8, bezier = "overshoot" })
hl.animation({ leaf = "windowsIn",     enabled = true, speed = 3.5, bezier = "easeOutExpo", style = "popin 90%" })
hl.animation({ leaf = "windowsOut",    enabled = true, speed = 3.0, bezier = "easeOutExpo", style = "popin 90%" })
hl.animation({ leaf = "fadeIn",        enabled = true, speed = 3.0, bezier = "easeOutExpo" })
hl.animation({ leaf = "fadeOut",       enabled = true, speed = 3.0, bezier = "easeOutExpo" })
hl.animation({ leaf = "layers",        enabled = true, speed = 4.0, bezier = "easeOutExpo" })
hl.animation({ leaf = "workspaces",    enabled = true, speed = 4.5, bezier = "easeOutExpo", style = "slide" })					
-- Ref https://wiki.hypr.land/Configuring/Basics/Workspace-Rules/
-- Smart gaps / No gaps when only one window is open
hl.workspace_rule({ workspace = "special:magic", gaps_out = 0, gaps_in = 0 }) -- Optional for scratchpad
hl.window_rule({
    name  = "smart-gaps-single",
    match = { float = false }, -- Only applies to tiled windows
    -- Note: Hyprland natively handles "gaps_out = 0 when only 1 window" if you just set:
})

-- See https://wiki.hypr.land/Configuring/Layouts/Dwindle-Layout/ for more
hl.config({
    dwindle = {
        preserve_split = true, -- You probably want this
    },
})

-- See https://wiki.hypr.land/Configuring/Layouts/Master-Layout/ for more
hl.config({
    master = {
        new_status = "master",
    },
})

-- See https://wiki.hypr.land/Configuring/Layouts/Scrolling-Layout/ for more
hl.config({
    scrolling = {
        fullscreen_on_one_column = true,
    },
})

----------------
----  MISC  ----
----------------

hl.config({
    misc = {
        force_default_wallpaper = 0, -- Disable anime mascot (0 = off)
        disable_hyprland_logo   = true, 
        vrr = 1, -- Enable Variable Refresh Rate (0=off, 1=on, 2=fullscreen only)
        mouse_move_enables_dpms = true,
    },
})

hl.config({
    input = {
        kb_layout  = "us",
        kb_variant = "",
        follow_mouse = 1,
        sensitivity = 0.0,
        numlock_by_default = true,
        touchpad = {
            natural_scroll = true, -- Feels much more modern and intuitive
            tap_to_click = true,
        },
    },
})


---------------
---- INPUT ----
---------------

hl.config({
    input = {
        kb_layout  = "us",
        kb_variant = "",
        kb_model   = "",
        kb_options = "",
        kb_rules   = "",

        follow_mouse = 1,

        sensitivity = 0, -- -1.0 - 1.0, 0 means no modification.

        touchpad = {
            natural_scroll = false,
        },
    },
})

hl.gesture({
    fingers = 3,
    direction = "horizontal",
    action = "workspace"
})

-- Example per-device config
-- See https://wiki.hypr.land/Configuring/Advanced-and-Cool/Devices/ for more
hl.device({
    name        = "epic-mouse-v1",
    sensitivity = -0.5,
})


---------------------
---- KEYBINDINGS ----
---------------------

-- === APPS ===
hl.bind(mainMod .. " + C", hl.dsp.window.close())

-- Move windows
hl.bind(mainMod .. " + SHIFT + H", hl.dsp.window.move({ direction = "left" }))
hl.bind(mainMod .. " + SHIFT + J", hl.dsp.window.move({ direction = "down" }))
hl.bind(mainMod .. " + SHIFT + K", hl.dsp.window.move({ direction = "up" }))
hl.bind(mainMod .. " + SHIFT + L", hl.dsp.window.move({ direction = "right" }))

-- Window states
hl.bind(mainMod .. " + M", hl.dsp.layout("togglesplit")) -- dwindle only "Not present in keybindings.lua"


-- === SCREENSHOT & CLIPBOARD ===
local screenshot_script = "/home/shadow/.config/hypr/scripts/screenshot.sh"
local screenshot_dir = "/home/shadow/Pictures/Screenshots"

-- Custom Area Screenshot (Grim + Slurp)
hl.bind("PRINT", hl.dsp.exec_cmd(screenshot_script)) 

-- Full Screen Screenshot (Direct Grim command)
hl.bind(mainMod .. " + PRINT", hl.dsp.exec_cmd("grim " .. screenshot_dir .. "/full_$(date +%H-%M-%S).png && wl-copy < " .. screenshot_dir .. "/full_*.png"))

-- Active Window Screenshot (Using grim's window mode)
hl.bind(mainMod .. " + CTRL + PRINT", hl.dsp.exec_cmd("grim -g \"$(hyprctl activewindow -j | jq -r '\"\\(.at[0]),\\(.at[1]) \\(.size[0])x\\(.size[1])\"')\" " .. screenshot_dir .. "/window_$(date +%H-%M-%S).png && wl-copy < " .. screenshot_dir .. "/window_*.png"))

-- Flameshot: Annotated GUI captures
hl.bind(mainMod .. " + SHIFT + PRINT", hl.dsp.exec_cmd("QT_QPA_PLATFORM=wayland flameshot gui -p " .. screenshot_dir .. " -c"))

-- Clipboard Manager: History UI (Unchanged)
hl.bind(mainMod .. " + SHIFT + V", hl.dsp.exec_cmd("cliphist list | wofi --dmenu | cliphist decode | wl-copy")) 


-- === EMOJI PICKER ===
-- Requires: wofi-emoji, wtype
hl.bind(mainMod .. " + PERIOD", hl.dsp.exec_cmd("wofi-emoji")) -- Opens glassy emoji picker for WhatsApp reactions

-- === LOCK SCREEN ===
-- Requires: hyprlock
hl.bind(mainMod .. " + ESCAPE", hl.dsp.exec_cmd("hyprlock"))


-- Scratchpad (Special Workspace)
hl.bind(mainMod .. " + S", hl.dsp.workspace.toggle_special("magic"))
hl.bind(mainMod .. " + SHIFT + S", hl.dsp.window.move({ workspace = "special:magic" }))

-- === MEDIA & HARDWARE KEYS (WITH OSD BARS) ===

-- Volume Keys
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("swayosd-client --output-volume raise"), { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("swayosd-client --output-volume lower"), { locked = true, repeating = true })
hl.bind("XF86AudioMute", hl.dsp.exec_cmd("swayosd-client --output-volume mute-toggle"), { locked = true })

-- === PASTE CLIPBOARD IMAGE AS FILE ===
hl.bind(mainMod .. " + CTRL+ V", hl.dsp.exec_cmd("~/.config/hypr/scripts/clip-save.sh"))

-- Brightness Keys
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("swayosd-client --brightness raise"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("swayosd-client --brightness lower"), { locked = true, repeating = true })

-- Media Playback Keys (No OSD needed for these)
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), { locked = true })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { locked = true })

--------------------------------
---- WINDOWS AND WORKSPACES ----
--------------------------------

-- See https://wiki.hypr.land/Configuring/Basics/Window-Rules/
-- and https://wiki.hypr.land/Configuring/Basics/Workspace-Rules/

-- Example window rules that are useful

local suppressMaximizeRule = hl.window_rule({
    -- Ignore maximize requests from all apps. You'll probably like this.
    name  = "suppress-maximize-events",
    match = { class = ".*" },

    suppress_event = "maximize",
})
-- suppressMaximizeRule:set_enabled(false)

hl.window_rule({
    -- Fix some dragging issues with XWayland
    name  = "fix-xwayland-drags",
    match = {
        class      = "^$",
        title      = "^$",
        xwayland   = true,
        float      = true,
        fullscreen = false,
        pin        = false,
    },

    no_focus = true,
})

-- Layer rules also return a handle.
-- local overlayLayerRule = hl.layer_rule({
--     name  = "no-anim-overlay",
--     match = { namespace = "^my-overlay$" },
--     no_anim = true,
-- })
-- overlayLayerRule:set_enabled(false)

-- Hyprland-run windowrule
hl.window_rule({
    name  = "move-hyprland-run",
    match = { class = "hyprland-run" },

    move  = "20 monitor_h-120",
    float = true,
})

hl.layer_rule({ match = { namespace = "rofi" }, blur = true, ignore_alpha = 0.65 })
-- ==========================================
-- QT CALENDAR POPUP (Kdialog)
-- ==========================================
hl.window_rule({
    name  = "kdialog-calendar",
    match = { class = "^kdialog$" },
    
    float = true,
    move  = "100%-540 45", -- Snaps to RHS below Waybar (100% width - 380px)
    size  = "500 650",     -- ~15cm width, ~20cm height
})

-- hl.bind("ESCAPE", hl.dsp.exec_cmd("hyprctl dispatch killactive"))
hl.bind(mainMod .. " + ALT + C", hl.dsp.exec_cmd("pkill wofi"))
