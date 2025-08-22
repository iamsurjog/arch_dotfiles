wkspc=$(hyprctl workspaces -j | jq -r '.[].name' | rofi -no-show-icons -keep-right -dmenu -i -p "Select Workspace:")
if [[ "$wkspc" =~ ^[0-9]+$ ]]; then
    hyprctl dispatch movetoworkspace "$wkspc"
else
    if hyprctl workspaces -j | jq -r '.[].name' | grep -qx "$wkspc"; then
        echo "$wkspc"
        hyprctl dispatch movetoworkspace "$wkspc"
    else
        hyprctl dispatch movetoworkspace "special:$wkspc"
    # hyprctl dispatch movetoworkspace "special:$wkspc"
    fi
fi

