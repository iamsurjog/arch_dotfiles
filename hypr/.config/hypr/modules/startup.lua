------------------
---- MONITORS ----
------------------
-- See https://wiki.hypr.land/Configuring/Basics/Monitors/

hl.monitor({
    output   = "eDP-1",
    mode     = "preferred",
    position = "0x0",
    scale    = "1",
    transform = 0
})
hl.monitor({ output = "HEADLESS-3", mode = "1920x1080", position = "2000x0", scale = "1.5", transform=1})



-------------------
---- AUTOSTART ----
-------------------

-- See https://wiki.hypr.land/Configuring/Basics/Autostart/

-- Autostart necessary processes (like notifications daemons, status bars, etc.)
-- Or execute your favorite apps at launch like this:
--
hl.on("hyprland.start", function () 
    -- necessary --
    hl.exec_cmd("nm-applet & blueman-applet & swayosd-server & swaync & awww-daemon & ")
    hl.exec_cmd("wl-paste --type text --watch cliphist store") -- Text --
    hl.exec_cmd("wl-paste --type image --watch cliphist store") -- Images --
    hl.exec_cmd("systemctl --user start hyprpolkitagent")
    hl.exec_cmd("systemctl --user enable opentabletdriver.service --now")

    -- scripts --
    hl.exec_cmd("/home/randomguy/surjo/path/vit_wifi.sh")
    hl.exec_cmd("/home/randomguy/.config/waybar/scripts/reset_workgroup.sh ")
    -- apps --
    hl.exec_cmd("waybar")
    hl.exec_cmd("qs -c quickshell-overview")
    hl.exec_cmd("qs -c hyprtodo")
    hl.exec_cmd("qs -c popout")

    hl.exec_cmd("cava-bg")
    hl.exec_cmd("tery")
    hl.exec_cmd("obsidian")
    hl.exec_cmd("firefoxpwa site launch 01KTRNY4TQ7P6ENTKPFAR3N935")
    hl.exec_cmd("/home/randomguy/.scripts/wayclick/wayclick.sh ")

    hl.exec_cmd("kitty")
end)


-------------------------------
---- ENVIRONMENT VARIABLES ----
-------------------------------

-- See https://wiki.hypr.land/Configuring/Advanced-and-Cool/Environment-variables/

hl.env("LIBVA_DRIVER_NAME", "nvidia")
hl.env("XDG_SESSION_TYPE", "wayland")
-- hl.env("GBM_BACKEND", "nvidia-drm") -- Disabled since firefox keeps crashing
hl.env("__GLX_VENDOR_LIBRARY_NAME", "nvidia")
hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_SIZE", "24")

hl.env("XDG_CURRENT_DESKTOP", "Hyprland")
hl.env("XDG_SESSION_DESKTOP", "Hyprland")

hl.env("QT_QPA_PLATFORM", "wayland;xcb")
hl.env("QT_QPA_PLATFORMTHEME", "qt5ct")
-- hl.env("QT_WAYLAND_DISABLE_WINDOWDECORATION", "1")
-- hl.env("QT_AUTO_SCREEN_SCALE_FACTOR", "1")
hl.env("QT_STYLE_OVERRIDE", "kvantum")
hl.env("AQ_DRM_DEVICES", "/dev/dri/card1:/dev/dri/card2")
hl.env("QS_NO_RELOAD_POPUP", "1")

