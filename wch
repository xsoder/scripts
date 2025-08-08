#!/bin/bash

dir="/home/$USER/Pictures/wallpapers/" # wallpapers folder, change it to yours, make sure that it ends with a /
cd $dir
wallpaper="none is selected"
set="feh --bg-fill"
view="feh"
selectpic(){
    wallpaper=$(ls $dir | rofi -dmenu -p "select a wallpaper: ($wallpaper)")

    if [[ $wallpaper == "q" || $wallpaper == "" ]]; then
        killall feh && exit
    else
        set_wall
    fi
}
set_wall(){
    $set $wallpaper && killall feh &
}

selectpic

