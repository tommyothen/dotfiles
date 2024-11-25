#!/bin/bash

# Specifically target Spotify
player_status=$(playerctl -p spotify status 2> /dev/null)

if [[ $? -eq 0 ]]; then
    title=$(playerctl -p spotify metadata title 2> /dev/null)
    artist=$(playerctl -p spotify metadata artist 2> /dev/null)
    album=$(playerctl -p spotify metadata album 2> /dev/null)
    position=$(playerctl -p spotify position 2> /dev/null | sed 's/\.[0-9]*//')
    length=$(playerctl -p spotify metadata mpris:length 2> /dev/null | sed 's/\.[0-9]*/./')
    volume=$(playerctl -p spotify volume 2> /dev/null)
    
    # Convert volume to percentage
    volume_percent=$(awk "BEGIN {print int($volume * 100)}")
    
    # Convert position to mm:ss
    position_formatted=$(date -d@"${position}" -u +%M:%S)
    
    # Convert length from microseconds to seconds and then to mm:ss
    length_seconds=$((length / 1000000))
    length_formatted=$(date -d@"${length_seconds}" -u +%M:%S)
    
    if [[ -n "$artist" ]]; then
        metadata="${artist} - ${title}"
        
        # Escape special characters in all text fields
        title=$(echo "$title" | sed 's/\\/\\\\/g' | sed 's/"/\\"/g')
        artist=$(echo "$artist" | sed 's/\\/\\\\/g' | sed 's/"/\\"/g')
        album=$(echo "$album" | sed 's/\\/\\\\/g' | sed 's/"/\\"/g')
        
        tooltip="♫ Now ${player_status}\\n"
        tooltip+="───────────────\\n"
        tooltip+="Title: ${title}\\n"
        tooltip+="Artist: ${artist}\\n"
        tooltip+="Album: ${album}\\n"
        tooltip+="Time: ${position_formatted}/${length_formatted}\\n"
        tooltip+="Volume: ${volume_percent}%\\n"
        tooltip+="───────────────\\n"
        tooltip+="Click to Play/Pause\\n"
        tooltip+="Right Click for Next\\n"
        tooltip+="Middle Click for Previous\\n"
        tooltip+="Scroll to Adjust Volume"
    else
        metadata="${title}"
        tooltip="${title}"
    fi

    if [[ $player_status = "Playing" ]]; then
        echo "{\"text\": \" ${metadata}\", \"class\": \"playing\", \"alt\": \"Playing\", \"tooltip\": \"${tooltip}\"}"
    else
        echo "{\"text\": \" ${metadata}\", \"class\": \"paused\", \"alt\": \"Paused\", \"tooltip\": \"${tooltip}\"}"
    fi
else
    echo "{\"text\": \" No music\", \"class\": \"stopped\", \"alt\": \"Stopped\", \"tooltip\": \"No music playing\"}"
fi
