wkspc=$(hyprctl workspaces -j | jq -r '.[].name' | rofi -no-show-icons -keep-right -dmenu -i -p "Select Workspace:")
if [ -n "$wkspc" ]; then
    if [[ "$wkspc" =~ ^[0-9]+$ ]]; then
        hyprctl dispatch workspace "$wkspc"
        active=$(hyprctl -j monitors | jq --raw-output '.[] | select(.focused==true).specialWorkspace.name | split(":") | if length > 1 then .[1] else "" end')

        if [[ ${#active} -gt 0 ]]; then
            hyprctl dispatch togglespecialworkspace "$active"
        fi
    else
        if hyprctl workspaces -j | jq -r '.[].name' | grep -qx "$wkspc"; then
            echo "$wkspc"
            hyprctl dispatch workspace "$wkspc"
        else
            hyprctl dispatch workspace "special:$wkspc"
            # hyprctl dispatch workspace "special:$wkspc"
        fi
    fi
fi
