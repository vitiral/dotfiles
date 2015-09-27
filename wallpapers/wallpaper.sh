#!/bin/sh

while true; do
    find ~/.dotfiles/wallpapers -type f \( -name '*.jpg' -o -name '*.png' \) -print0 |
        shuf -n1 -z | xargs -0 feh --bg-center
    sleep 30m
done
