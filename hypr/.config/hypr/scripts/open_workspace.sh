input_file="$HOME/.config/hypr/scripts/workspace.txt"
# input_file="workspace.txt"

# Read the number from the file (assuming the file has only one number)
number=$(cat "$input_file")

# Define the constant number to add
constant=$1

# Add the numbers and print the result
result=$((number * 10 + constant))
# notify-send -i dialog-information-symbolic "$number"  

hyprctl dispatch workspace $result
