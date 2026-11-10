selected_theme=$((echo "default"; gowall list) | rofi -no-show-icons -keep-right -dmenu -i -p "Select Theme")

if [ -n "$selected_theme" ]; then
    if [ "$selected_theme" = "default" ]; then
        /home/randomguy/.config/quickshell/hyprquickpaper/commands.sh /home/randomguy/Pictures/wallpaper_def.png
    else
        gowall convert /home/randomguy/Pictures/wallpaper_def.png -t $selected_theme - > /home/randomguy/Pictures/wallpaper_themed.png 
        awww img /home/randomguy/Pictures/wallpaper_themed.png -t grow --transition-duration 1
        wallust run /home/randomguy/Pictures/wallpaper_themed.png
        cp /home/randomguy/Pictures/wallpaper_themed.png /home/randomguy/Pictures/wallpaper.png
    fi
fi

