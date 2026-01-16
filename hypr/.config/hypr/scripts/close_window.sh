WIN=$(hyprctl activewindow)

if [ "$WIN" = "Invalid" ]; then
    wlogout -b 4 -T 380 -B 380
else
    hyprctl dispatch killactive
fi

