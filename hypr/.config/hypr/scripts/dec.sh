input_file="$HOME/.config/hypr/scripts/workspace.txt"

# Read the number from the file
number=$(cat "$input_file")

# Decrease the number but don't go below zero
if (( number > 0 )); then
  number=$((number - 1))
fi

# Store the updated number back to the file
echo "$number" > "$input_file"

