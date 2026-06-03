wkspc=$(hyprctl workspaces -j | jq -r '.[].name' | rofi -no-show-icons -keep-right -dmenu -i -p "Select Workspace:")

if [ -n "$wkspc" ]; then
    if [[ "$wkspc" =~ ^[0-9]+$ ]]; then
        hyprctl dispatch "hl.dsp.focus({ workspace =\"$wkspc\"})"
        active_special=$(hyprctl monitors -j | jq -r '.[] | select(.focused==true).specialWorkspace.name | sub("special:"; "")')

        if [ -n "$active_special" ]; then
            hyprctl dispatch "hl.dsp.workspace.toggle_special({ name = \"$active\" })"
            hyprctl dispatch "hl.dsp.workspace.toggle_special({ name = special })"
        fi
    else
        hyprctl dispatch "hl.dsp.focus({ workspace = \"$wkspc\"})"
    fi
fi

