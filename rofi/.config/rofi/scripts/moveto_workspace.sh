wkspc=$(hyprctl workspaces -j | jq -r '.[].name' | rofi -no-show-icons -keep-right -dmenu -i -p "Select Workspace:")

if [ -n "$wkspc" ]; then
    if [[ "$wkspc" =~ ^[0-9]+$ ]]; then
        hyprctl dispatch "hl.dsp.window.move({ workspace =\"$wkspc\"})"
    else
        hyprctl dispatch "hl.dsp.window.move({ workspace = \"$wkspc\"})"
    fi
fi

