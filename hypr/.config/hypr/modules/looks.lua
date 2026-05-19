-----------------------
---- LOOK AND FEEL ----
-----------------------

-- Refer to https://wiki.hypr.land/Configuring/Basics/Variables/
hl.config({
    general = {
        gaps_in  = 5,
        gaps_out = 5,

        border_size = 2,

        col = {
            active_border   = { colors = {"rgba(33ccffee)", "rgba(00ff99ee)"}, angle = 45 },
            inactive_border = "rgba(595959aa)",
        },

        -- Set to true to enable resizing windows by clicking and dragging on borders and gaps
        resize_on_border = false,

        -- Please see https://wiki.hypr.land/Configuring/Advanced-and-Cool/Tearing/ before you turn this on
        allow_tearing = false,

        layout = "dwindle",
    },

    decoration = {
        rounding       = 10,
        rounding_power = 2,

        -- Change transparency of focused and unfocused windows
        active_opacity   = 1.0,
        inactive_opacity = 1.0,

        -- TODO: READ THIS PART
        shadow = {
            enabled = true,
            -- ignore_window = true,
            range = 20,
            -- offset = 0 4,
            render_power = 4,
            color = 0x00000028,
        },

        blur = {
            enabled = true,
            xray = false,
            special = false,
            new_optimizations = true,
            size = 5,
            passes = 2,
            brightness = 1,
            noise = 0.01,
            contrast = 1.2,
            popups = true,
            popups_ignorealpha = 0.6,
        },
    },

    animations = {
        enabled = true,
    },
})

-- TODO: animations
-- Default curves and animations, see https://wiki.hypr.land/Configuring/Advanced-and-Cool/Animations/
hl.curve("easeOutQuint",   { type = "bezier", points = { {0.23, 1},    {0.32, 1}    } })
hl.curve("easeInOutCubic", { type = "bezier", points = { {0.65, 0.05}, {0.36, 1}    } })
hl.curve("linear",         { type = "bezier", points = { {0, 0},       {1, 1}       } })
hl.curve("almostLinear",   { type = "bezier", points = { {0.5, 0.5},   {0.75, 1}    } })
hl.curve("quick",          { type = "bezier", points = { {0.15, 0},    {0.1, 1}     } })
hl.curve("linear", { type = "bezier", points = { {0, 0}, {1, 1} }})
hl.curve("md3_standard", { type = "bezier", points = { {0.2, 0}, {0, 1} }})
hl.curve("md3_decel", { type = "bezier", points = { {0.05, 1.15}, {0.1, 1} }})
hl.curve("md3_accel", { type = "bezier", points = { {0.3, 0}, {0.8, 0.15} }})
hl.curve("overshot", { type = "bezier", points = { {0.05, 0.9}, {0.1, 1.1} }})
hl.curve("crazyshot", { type = "bezier", points = { {0.1, 1.5}, {0.76, 0.92 } }})
hl.curve("hyprnostretch", { type = "bezier", points = { {0.05, 0.9}, {0.1, 1.0} }})
hl.curve("menu_decel", { type = "bezier", points = { {0.1, 1}, {0, 1} }})
hl.curve("menu_decel2", { type = "bezier", points = { {0.1, 1.2}, {0, 1} }})
hl.curve("menu_accel", { type = "bezier", points = { {0.38, 0.04}, {1, 0.07} }})
hl.curve("easeInOutCirc", { type = "bezier", points = { {0.85, 0}, {0.15, 1} }})
hl.curve("easeOutCirc", { type = "bezier", points = { {0, 0.55}, {0.45, 1} }})
hl.curve("easeOutExpo", { type = "bezier", points = { {0.16, 1}, {0.3, 1} }})
hl.curve("softAcDecel", { type = "bezier", points = { {0.26, 0.26}, {0.15, 1} }})
hl.curve("md2", { type = "bezier", points = { {0.4, 0}, {0.2, 1} }})


-- Default springs
hl.animation({leaf = "windows", enabled = true, speed = 5, bezier = "menu_decel2"})
hl.animation({leaf = "windowsIn", enabled = true, speed = 5, bezier = "menu_decel2"})
hl.animation({leaf = "windowsOut", enabled = true, speed = 3, bezier = "md3_accel"})
hl.animation({leaf = "border", enabled = true, speed = 10, bezier = "default"})
hl.animation({leaf = "fade", enabled = true, speed = 3, bezier = "easeOutExpo"})
hl.animation({leaf = "layersIn", enabled = true, speed = 3, bezier = "menu_decel2", style = "slide"})
hl.animation({leaf = "layersOut", enabled = true, speed = 1, bezier = "menu_decel2", style = "slide"})
hl.animation({leaf = "fadeLayersIn", enabled = true, speed = 2, bezier = "menu_decel"})
hl.animation({leaf = "fadeLayersOut", enabled = true, speed = 4.5, bezier = "menu_accel"})
hl.animation({leaf = "workspaces", enabled = true, speed = 5, bezier = "md3_decel"})
hl.animation({leaf = "specialWorkspace", enabled = true, speed = 5, bezier = "md3_decel", style = "slidevert"})


-- Ref https://wiki.hypr.land/Configuring/Basics/Workspace-Rules/
-- "Smart gaps" / "No gaps when only"
-- uncomment all if you wish to use that.
-- hl.workspace_rule({ workspace = "w[tv1]", gaps_out = 0, gaps_in = 0 })
-- hl.workspace_rule({ workspace = "f[1]",   gaps_out = 0, gaps_in = 0 })
-- hl.window_rule({
--     name  = "no-gaps-wtv1",
--     match = { float = false, workspace = "w[tv1]" },
--     border_size = 0,
--     rounding    = 0,
-- })
-- hl.window_rule({
--     name  = "no-gaps-f1",
--     match = { float = false, workspace = "f[1]" },
--     border_size = 0,
--     rounding    = 0,
-- })

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

