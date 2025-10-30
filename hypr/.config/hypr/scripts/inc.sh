input_file="$HOME/.config/hypr/scripts/workspace.txt"

# Read the number from the file
number=$(cat "$input_file")

# Increment the number (no spaces around =, and use arithmetic expansion)
number=$((number + 1))

# Store the incremented number back to the file
echo "$number" > "$input_file"

