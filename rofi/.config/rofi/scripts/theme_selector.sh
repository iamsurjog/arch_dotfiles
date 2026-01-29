selected_theme=$((echo "default"; gowall list) | rofi -no-show-icons -keep-right -dmenu -i -p "Select Theme")

if [ -n "$selected_theme" ]; then
    if [ "$selected_theme" = "default" ]; then
        waypaper --wallpaper /home/randomguy/Pictures/wallpaper_def.png
    else
        gowall convert /home/randomguy/Pictures/wallpaper_def.png -t $selected_theme - > /home/randomguy/Pictures/wallpaper_themed.png 
        waypaper --wallpaper /home/randomguy/Pictures/wallpaper_themed.png
    fi
fi

