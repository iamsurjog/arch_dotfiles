selected_dir=$(ls $HOME/sess/ | sed 's/\.[^.]*$//'| rofi -no-show-icons -keep-right -dmenu -i -p "Select directory:")
if [ -n "$selected_dir" ]; then
    kitty --session "$HOME/sess/""$selected_dir"".kitty-session"
fi
