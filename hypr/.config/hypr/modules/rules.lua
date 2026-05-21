---------------
---- INPUT ----
---------------

hl.config({
    input = {
        kb_layout  = "us",
        kb_variant = "",
        kb_model   = "",
        kb_options = "caps:swapescape",
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
-- Layer rules also return a handle.
hl.layer_rule({
    name  = "no-anim-overlay",
    match = { namespace = "^my-overlay$" },
    no_anim = true,
})
-- overlayLayerRule:set_enabled(false)


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


hl.window_rule({
    name  = "thunar-rename-float",
    match = {
        class = "^(thunar)$",
        title = "^Rename.*",
    },
    float = true,
})

hl.window_rule({
    -- volume control window rule pavo
    name  = "Pavu",
    match = { title = "^(Volume Control)$" },
    float = true,
    move  = { "window_h*0.5", "window_w * 0.055" },
})


hl.window_rule({
    name  = "firefox-pip",
    match = {
        class = "^(firefox)$",
        title = "^(Picture-in-Picture)$",
    },
    pin   = true,
    move  = { "100%-w-5", "58" },
    float = true,
})

hl.window_rule({
    -- spotify window rule
    name  = "spotify-workspace",
    match = { class = "^(Spotify)$" },
    workspace = "special:Music",
})

hl.window_rule({
    -- spotify window rule
    name  = "whatsapp-workspace",
    match = { initial_title = "^(Whatsapp)$" },
    workspace = "special:Chat",
})

hl.window_rule({
    -- vesktop picture in picture
    name  = "vesktop",
    match = {
        initial_title = "^(Discord)$",
    },
    workspace = "special:Discord",
})

hl.window_rule({
    -- vesktop picture in picture
    name  = "vesktop-pip-float",
    match = {
        initial_class = "^(vesktop)$",
        initial_title = "^(Discord Popout)$",
    },
    float = true,
    move  = "100% w-5",
    pin   = true,
})


hl.window_rule({
    name  = "obsidian",
    match = { initial_title = "^(.* - Obsidian).*$" },
    opacity = "0.9 0.8",
    workspace = "special:Task",
})

hl.window_rule({
    name  = "thunar-opacity",
    match = { class = "^(thunar)$" },
    opacity = "0.8 0.7",
})


---------------------------
------- LAYER RULES -------
---------------------------
hl.layer_rule({
    name  = "rofi-blur",
    match = { namespace = "rofi" },
    blur  = true,
})

hl.layer_rule({
    name  = "quickshell-blur",
    match = { namespace = "quickshell" },
    blur  = true,
})

hl.layer_rule({
    name  = "waybar-blur-alpha",
    match = { namespace = "waybar" },
    blur         = true,
    ignore_alpha = 0.8,
})

hl.layer_rule({
    name  = "swaync-control-center-blur-alpha",
    match = { namespace = "swaync-control-center" },
    blur         = true,
    ignore_alpha = 0.1,
})

hl.layer_rule({
    name  = "logout-dialog-rules",
    match = { namespace = "logout_dialog" },
    blur         = true,
    animation    = "popin",
    ignore_alpha = 0.01,
})
