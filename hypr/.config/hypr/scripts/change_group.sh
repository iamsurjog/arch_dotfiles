input_file="$HOME/.config/hypr/scripts/workspace.txt"

# Read the number from the file
number=$1

# Increment the number (no spaces around =, and use arithmetic expansion)
number=$((number))

result=$((number * 10 + 1))
# Store the incremented number back to the file
echo "$number" > "$input_file"
hyprctl dispatch workspace $result

