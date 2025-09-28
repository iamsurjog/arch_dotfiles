#!/bin/bash

echo "Wallpaper being used is $1"
wallust run $1
cp $1 ~/Pictures/wallpaper.png
killall -SIGUSR2 waybar 
swaync-client -rs
notify-send -i dialog-information-symbolic "Changing wallpaper and colorscheme" "Waypaper at work"
killall quickshell
cp ~/.cache/temp/Colours.qml ~/.config/quickshell/popout/services/Colours.qml
rm ~/.cache/temp/Colours.qml
quickshell --config popout
pywalfox update
killall swayosd-server
spicetify apply
sleep 0.5
swayosd-server
