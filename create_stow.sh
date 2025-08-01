mkdir $1/.config/$1 -p
mv ~/.config/$1 $1/.config/$1
stow -t ~ $1
