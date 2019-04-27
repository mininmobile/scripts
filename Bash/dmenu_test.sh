#!/bin/sh
# show a dmenu list of profanities that can be copied to clipboard

chosen=$(echo "fuck
shit
bitch
nigga
ass
cracka
cunt
twat
ballsack
heck
frick
dong
penis
dick
vagina" | dmenu -p "whomst?")

[ "$chosen" != "" ] || exit

echo "$chosen" | tr -d '\n' | xclip -selection clipboard
notify-send "'$chosen' copied to clipboard."
