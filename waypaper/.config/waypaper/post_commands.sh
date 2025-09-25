#!/bin/bash

echo "Wallpaper being used is $1"
wallust run $1
cp $1 ~/Pictures/wallpaper.png
killall -SIGUSR2 waybar 
swaync-client -rs
notify-send -i dialog-information-symbolic "Changing wallpaper and colorscheme" "Waypaper at work"
pywalfox update
killall swayosd-server
spicetify apply
sleep 0.5
killall quickshell
quickshell --config popout3 
swayosd-server
