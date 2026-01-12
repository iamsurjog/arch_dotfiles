WIN=$(hyprctl activewindow)

if [ "$WIN" = "Invalid" ]; then
    wlogout -b 2
else
    hyprctl dispatch killactive
fi

