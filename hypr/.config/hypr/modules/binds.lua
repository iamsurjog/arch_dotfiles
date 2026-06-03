----------------------
---- MY VARIABLES ----
----------------------

local group       = 0
local terminal    = "kitty"
local fileManager = "thunar"
local menu        = "rofi -show drun"
local browser     = "firefox"

function CloseSpecialWorkspace()
    local current = hl.get_active_special_workspace()
    if current then
        hl.dispatch(hl.dsp.workspace.toggle_special(current.config_name))
    end
end

local mainMod = "SUPER" -- Sets "Windows" key as main modifier
-- hl.bind(mainMod .. " + SHIFT + equal", hl.dsp.window.move({ workspace = "+1" }))
-- hl.bind(mainMod .. " + minus",   hl.dsp.focus({ workspace = "-1" }))
-- hl.bind(mainMod .. " + SHIFT + minus", hl.dsp.window.move({ workspace = "-1" }))


function GroupManage(command)
    if command == "go" then
    end
end

---------------------
---- KEYBINDINGS ----
---------------------


hl.bind(mainMod .. " + CTRL + ALT + SHIFT + M",
    hl.dsp.exec_cmd("command -v hyprshutdown >/dev/null 2>&1 && hyprshutdown || hyprctl dispatch 'hl.dsp.exit()'"))

-- Example binds, see https://wiki.hypr.land/Configuring/Basics/Binds/ for more
hl.bind(mainMod .. " + Return", hl.dsp.exec_cmd(terminal))
hl.bind(mainMod .. " + SHIFT + Return", hl.dsp.exec_cmd(browser))
hl.bind(mainMod .. " + Q", hl.dsp.window.close())

-- closeWindowBind:set_enabled(false)
hl.bind(mainMod .. " + E", hl.dsp.exec_cmd(fileManager))
hl.bind(mainMod .. " + SHIFT + E", hl.dsp.exec_cmd("~/.config/rofi/scripts/folder_opener.sh"))
hl.bind(mainMod .. " + V", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + SUPER_L", hl.dsp.exec_cmd("pkill rofi || " .. menu), { release = true })
hl.bind(mainMod .. " + I", hl.dsp.exec_cmd("/home/randomguy/.scripts/wayclick/wayclick.sh"))
hl.bind(mainMod .. " + P", hl.dsp.exec_cmd("~/.config/rofi/scripts/theme_selector.sh"))
hl.bind(mainMod .. " + R", hl.dsp.exec_cmd("~/.config/hypr/scripts/random_wallpaper.sh"))
hl.bind(mainMod .. " + W", hl.dsp.exec_cmd("qs -c hyprquickpaper"))
hl.bind(mainMod .. " + ALT + W", hl.dsp.exec_cmd("waybar"))
hl.bind(mainMod .. " + SHIFT + W", hl.dsp.exec_cmd("killall waybar"))

-- hl.bind(mainMod .. " + P", hl.dsp.window.pseudo())
-- hl.bind(mainMod .. " + J", hl.dsp.layout("togglesplit"))    -- dwindle only
hl.bind(mainMod .. " + SPACE", hl.dsp.exec_cmd("~/.config/rofi/scripts/goto_workspaces.sh"))
hl.bind(mainMod .. " + SHIFT + SPACE", hl.dsp.exec_cmd("~/.config/rofi/scripts/moveto_workspace.sh"))

-- Move focus with mainMod + arrow keys
hl.bind(mainMod .. " + h", hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + l", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + k", hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + j", hl.dsp.focus({ direction = "down" }))

hl.bind(mainMod .. " + TAB", function ()
    hl.dispatch( hl.dsp.focus({ workspace = "previous" }) )
    CloseSpecialWorkspace()
    CloseSpecialWorkspace()
end)
hl.bind(mainMod .. " + CTRL + L", hl.dsp.exec_cmd("hyprlock"))
-- Switch workspaces with mainMod + [0-9]
-- Move active window to a workspace with mainMod + SHIFT + [0-9]
for i = 1, 10 do
    local key = i % 10 -- 10 maps to key 0

    -- Dynamic switching
    hl.bind(mainMod .. " + " .. key, function()
        CloseSpecialWorkspace()
        CloseSpecialWorkspace()

        -- Calculate workspace on-the-fly using the live 'group' value
        local target_workspace_id = i + (group * 10)
        local target_ws = hl.get_workspace(target_workspace_id)

        hl.dispatch(hl.dsp.focus({ workspace = target_workspace_id }))

        if target_ws and target_ws.last_window then
            hl.dispatch(hl.dsp.focus({ window = target_ws.last_window }))
        end
    end)

    -- Dynamic moving
    hl.bind(mainMod .. " + SHIFT + " .. key, function()
        local target_workspace_id = i + (group * 10)
        hl.dispatch(hl.dsp.window.move({ workspace = target_workspace_id }))
    end)
end

-- Example special workspace (scratchpad)
hl.bind(mainMod .. " + M", hl.dsp.workspace.toggle_special("Music"))
hl.bind(mainMod .. " + SHIFT + M", hl.dsp.window.move({ workspace = "special:Music" }))
hl.bind(mainMod .. " + C", hl.dsp.workspace.toggle_special("Chat"))
hl.bind(mainMod .. " + SHIFT + C", hl.dsp.window.move({ workspace = "special:Chat" }))
hl.bind(mainMod .. " + T", hl.dsp.workspace.toggle_special("Task"))
hl.bind(mainMod .. " + SHIFT + T", hl.dsp.window.move({ workspace = "special:Task" }))
hl.bind(mainMod .. " + B", hl.dsp.workspace.toggle_special("bg"))
hl.bind(mainMod .. " + SHIFT + B", hl.dsp.window.move({ workspace = "special:bg" }))
hl.bind(mainMod .. " + G", hl.dsp.workspace.toggle_special("Gaem"))
hl.bind(mainMod .. " + SHIFT + G", hl.dsp.window.move({ workspace = "special:Gaem" }))
hl.bind(mainMod .. " + D", hl.dsp.workspace.toggle_special("Discord"))
hl.bind(mainMod .. " + SHIFT + D", hl.dsp.window.move({ workspace = "special:Discord" }))

-- Scroll through existing workspaces with mainMod + +/-
hl.bind(mainMod .. " + equal", function()
    hl.dispatch(hl.dsp.focus({ workspace = "+1" }))
    CloseSpecialWorkspace()
    CloseSpecialWorkspace()
end)
hl.bind(mainMod .. " + SHIFT + equal", hl.dsp.window.move({ workspace = "+1" }))
hl.bind(mainMod .. " + minus", function()
    hl.dispatch(hl.dsp.focus({ workspace = "-1" }))
    CloseSpecialWorkspace()
    CloseSpecialWorkspace()
end)
hl.bind(mainMod .. " + SHIFT + minus", hl.dsp.window.move({ workspace = "-1" }))
hl.bind(mainMod .. " + CTRL + equal", function()
    hl.dispatch(hl.dsp.focus({ workspace = "+10" }))
    group = group + 1
    CloseSpecialWorkspace()
    CloseSpecialWorkspace()
end)
hl.bind(mainMod .. " + CTRL + minus", function()
    hl.dispatch(hl.dsp.focus({ workspace = "-10" }))
    group = math.max(0, group - 1)
    CloseSpecialWorkspace()
    CloseSpecialWorkspace()
end)
hl.bind(mainMod .. " + CTRL + SHIFT + equal", function()
    hl.dispatch(hl.dsp.window.move({ workspace = "+10" }))
    group = group + 1
end)
hl.bind(mainMod .. " + CTRL + SHIFT + minus", function()
    hl.dispatch(hl.dsp.window.move({ workspace = "-10" }))
    group = group - 1
end)

-- Move/resize windows with mainMod + LMB/RMB and dragging
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- Laptop multimedia keys for volume and LCD brightness
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("swayosd-client --output-volume raise"), { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("swayosd-client --output-volume lower"), { locked = true, repeating = true })
hl.bind("XF86AudioMute", hl.dsp.exec_cmd("swayosd-client --output-volume mute-toggle"),
    { locked = true, repeating = true })
-- hl.bind("XF86AudioMicMute",     hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"),   { locked = true, repeating = true })
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("swayosd-client --brightness raise"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("swayosd-client --brightness lower"),
    { locked = true, repeating = true })
hl.bind("CTRL + Prior", hl.dsp.exec_cmd("swayosd-client --input-volume raise"), { locked = true, repeating = true })
hl.bind("CTRL + Next", hl.dsp.exec_cmd("swayosd-client --input-volume lower"), { locked = true, repeating = true })
hl.bind("Prior", hl.dsp.exec_cmd("swayosd-client --brightness raise"), { locked = true, repeating = true })
hl.bind("Next", hl.dsp.exec_cmd("swayosd-client --brightness lower"), { locked = true, repeating = true })
hl.bind("XF86Calculator", hl.dsp.exec_cmd("pkill rofi || rofi -show calc"), { locked = true, repeating = true })

-- Requires playerctl
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { locked = true })

hl.bind(mainMod .. " + N", hl.dsp.exec_cmd("swaync-client -t -sw"))
hl.bind(mainMod .. " + F", hl.dsp.window.fullscreen(0))
hl.bind("Print",
    hl.dsp.exec_cmd(
        "grim  - | satty --filename - --output-filename ~/Pictures/Screenshots/screenshot-$(date '+%Y%m%d-%H:%M:%S').png --copy-command 'wl-copy'"))
hl.bind(mainMod .. " + SHIFT + S", hl.dsp.exec_cmd("quickshell -c hyprquickshot -n"))
hl.bind(mainMod .. " + SHIFT + O", hl.dsp.exec_cmd("quickshell -c hyprquicksnip -n"))
hl.bind(mainMod .. " + SHIFT + V",
    hl.dsp.exec_cmd("cliphist list | rofi -dmenu -no-show-icons false | cliphist decode | wl-copy"))
hl.bind(mainMod .. " + period", hl.dsp.exec_cmd("rofimoji -a copy"))
hl.bind(mainMod .. " + CTRL + SHIFT + C", hl.dsp.exec_cmd("hyprpicker | wl-copy"))
hl.bind(mainMod .. " + CTRL + TAB", hl.dsp.exec_cmd("qs ipc -c quickshell-overview call overview toggle"))

-- TODO: thgese binds
-- bind = $mainMod, SPACE, exec, ~/.config/rofi/scripts/goto_workspaces.sh
-- bind = $mainMod SHIFT, SPACE, exec, ~/.config/rofi/scripts/moveto_workspace.sh
-- bind = $mainMod, s, exec, ~/.config/rofi/scripts/sess.sh
