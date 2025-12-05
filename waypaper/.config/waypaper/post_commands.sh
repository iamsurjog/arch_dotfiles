#!/bin/bash

echo "Wallpaper being used is $1"
wallust run $1
cp $1 ~/Pictures/wallpaper.png
# swww img ~/Pictures/wallpaper.png -t grow --transition-duration 1
killall -SIGUSR2 waybar 
swaync-client -rs
notify-send -i dialog-information-symbolic "Changing wallpaper and colorscheme" "Waypaper at work"
killall quickshell
cp ~/.cache/temp/Colours.qml ~/.config/quickshell/popout/services/Colours.qml
rm ~/.cache/temp/Colours.qml
quickshell --config popout
pywalfox update
killall swayosd-server
if pgrep -x "spotify" > /dev/null; then
    spicetify apply
fi

sleep 0.5
swayosd-server
